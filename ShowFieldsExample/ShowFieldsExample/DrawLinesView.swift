import UIKit
import SpriteKit

/// A `UIView` that only draws lines.
///
/// To use it, first set the `lines` property and then call `displayNow()`.
class DrawLinesView: UIView {

    private static let defaultStrokeColor = CGColor(red: 0, green: 1, blue: 1, alpha: 1)

    /// Lines to be drawn in the view.
    /// Each `[CGPoint]` represents a sequence of points that will be connected with a path.
    var lines = [[CGPoint]]()

    /// Color to stroke the drawn lines.
    var strokeColor: CGColor

    /// Width of the drawn lines.
    var lineWidth: CGFloat

    init(frame: CGRect, strokeColor: CGColor = defaultStrokeColor, lineWidth: CGFloat = 1) {
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        super.init(frame: frame)
    }

    /// Call this method after setting `lines` property to immediately draw the view.
    func displayNow() {
        let layer = self.layer
        layer.setNeedsDisplay()
        layer.displayIfNeeded()
    }

    /// Draw `lines` in the view.
    override func draw(_ layer: CALayer, in context: CGContext) {
        context.setStrokeColor(strokeColor)
        context.setLineWidth(lineWidth)

        for line in lines {
            guard line.count >= 2 else {
                return
            }

            context.move(to: line.first!)
            for index in 1 ..< line.count {
                context.addLine(to: line[index])
            }
        }

        context.strokePath()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
