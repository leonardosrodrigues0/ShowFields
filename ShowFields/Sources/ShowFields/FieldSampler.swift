import SpriteKit

/// Class responsible for sampling the scene's field and
/// translating it into lines to be drawn.
public class FieldSampler {

    /// Scene that owns this sampler.
    public weak var scene: SKScene? {
        didSet {
            updateSpacing()
        }
    }

    /// View responsible to draw the field sampled.
    private weak var drawView: DrawLinesView?

    /// Number of indicators to be displayed in the height of the scene.
    private let indicatorsPerColumn: Int

    /// Number of indicators to be displayed in the width of the scene.
    ///
    /// Calculated based on `indicatorsPerColumn`, such that the spacing is equal.
    private var indicatorsPerLine: Int = 20

    /// The spacing between field indicators, both on vertical and horizontal directions.
    private var indicatorSpacing: CGFloat = 100

    /// Creates a field sampler.
    /// - Parameters:
    ///   - view: The view that will be told to draw the lines representing the field.
    ///   - indicatorsPerColumn: Number of field indicators in a vertical column.
    ///   Will be used to create equal spaced indicators in horizontal lines as well.
    public init(view: DrawLinesView?, indicatorsPerColumn: Int = 36) {
        self.drawView = view
        self.indicatorsPerColumn = indicatorsPerColumn
    }

    /// Sample fields in `scene` and ask `drawView` to draw them.
    public func updateLines() {
        if let pointsToDraw = calculatePointsToDraw() {
            drawView?.lines = pointsToDraw
            drawView?.displayNow()
        }
    }

    /// For each point in the scene matrix (size `indicatorsPerColumn` x `indicatorsPerLine`),
    /// sample the scene field and convert it to the points to draw in the view using `scaleFieldToIndicator`
    /// and `scene.convertPoint(toView:)`.
    private func calculatePointsToDraw() -> [[CGPoint]]? {
        guard let scene else {
            print("No scene found when calculating points to draw")
            return nil
        }

        var pointsToDraw = [[CGPoint]]()

        for yIndex in 0 ..< indicatorsPerColumn {
            for xIndex in 0 ..< indicatorsPerLine {
                let position = CGPoint(
                    x: CGFloat(xIndex) * indicatorSpacing,
                    y: CGFloat(yIndex) * indicatorSpacing
                )

                // Return to avoid drawing field in a
                // bug situation (explained in `sampleField(scene:at:)`).
                guard let field = sampleField(at: position) else {
                    print("Not updating field indicators this frame")
                    return nil
                }

                var indicator = scaleFieldToIndicator(field)

                // Small indicator to avoid empty background:
                if indicator == .zero {
                    indicator = CGVector(dx: 2, dy: 2)
                }

                pointsToDraw.append([
                    scene.convertPoint(toView: position),
                    scene.convertPoint(toView: position.sum(with: indicator))
                ])
            }
        }

        return pointsToDraw
    }

    /// Sample the scene field at `position` and transform it into a `CGVector`.
    private func sampleField(at position: CGPoint) -> CGVector? {
        guard let scene else {
            print("No scene found when sampling field")
            return nil
        }

        let field = scene.physicsWorld.sampleFields(at: vector_float3(
            Float(position.x),
            Float(position.y),
            0
        ))

        // Check for NaN results because they cause a bug in which there's a non
        // existing field drawn in (0, 0) whenever a new touch begins.
        // This fix makes the view not draw the scene's field in these situations.
        if field.x.isNaN || field.y.isNaN {
            if position == .zero {
                return nil
            } else {
                return .zero
            }
        } else {
            return CGVector(
                dx: CGFloat(field.x),
                dy: CGFloat(field.y)
            )
        }
    }

    /// Function that scale the field from its measured magnitude to the size of the indicator displayed on screen.
    ///
    /// Any non linear implementation of this method leads to a physically unrealistic representation of the
    /// field, but can be better for the visualization.
    private func scaleFieldToIndicator(_ field: CGVector) -> CGVector {
        return field.normalized().multiply(scalar: 15 * pow(field.magnitude, 0.3))
    }

    /// Update `indicatorSpacing` and `indicatorsPerLine` according to the scene size
    /// and the sampler's `indicatorsPerColumn`.
    private func updateSpacing() {
        if let scene {
            indicatorSpacing = scene.size.height / CGFloat(indicatorsPerColumn)
            indicatorsPerLine = Int(ceil(scene.size.width / indicatorSpacing))
        }
    }
}
