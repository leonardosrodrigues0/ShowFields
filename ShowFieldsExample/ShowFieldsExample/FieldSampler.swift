import SpriteKit

/// Class responsible for sampling the scene's field and
/// translating it into lines to be drawn.
class FieldSampler {

    /// Scene that owns this sampler.
    private weak var scene: GameScene!

    /// View responsible to draw the field sampled.
    private weak var drawView: DrawLinesView?

    /// Number of indicators to be displayed in the height of the scene.
    private let indicatorsPerColumn: Int = 36

    /// Number of indicators to be displayed in the width of the scene.
    ///
    /// Calculated based on `indicatorsPerColumn`, such that the spacing is equal.
    private let indicatorsPerLine: Int

    /// The spacing between field indicators, both on vertical and horizontal directions.
    private let indicatorSpacing: CGFloat

    init(scene: GameScene, view: DrawLinesView?) {
        self.scene = scene
        self.drawView = view
        indicatorSpacing = scene.size.height / CGFloat(indicatorsPerColumn)
        indicatorsPerLine = Int(ceil(scene.size.width / indicatorSpacing))
    }

    /// Sample fields in scene and ask `drawView` to draw them.
    func updateLines() {
        if let pointsToDraw = calculatePointsToDraw() {
            drawView?.lines = pointsToDraw
            drawView?.displayNow()
        }
    }

    /// For each point in the scene matrix (size `indicatorsPerColumn` x `indicatorsPerLine`),
    /// sample the scene field and convert it to the points to draw in the view using `scaleFieldToIndicator`
    /// and `scene.convertPoint(toView:)`.
    private func calculatePointsToDraw() -> [[CGPoint]]? {
        var pointsToDraw = [[CGPoint]]()

        for yIndex in 0 ..< indicatorsPerColumn {
            for xIndex in 0 ..< indicatorsPerLine {
                let position = CGPoint(
                    x: CGFloat(xIndex) * indicatorSpacing,
                    y: CGFloat(yIndex) * indicatorSpacing
                )

                // Return to avoid drawing field in a
                // bug situation (explained in `sampleField(scene:at:)`).
                guard let field = sampleField(scene: scene, at: position) else {
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
    private func sampleField(scene: GameScene, at position: CGPoint) -> CGVector? {
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
}
