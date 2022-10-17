import CoreGraphics

extension CGPoint {

    init(from vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }

    func sum(with vector: CGVector) -> CGPoint {
        let selfVector = CGVector(pointA: .zero, pointB: self)
        let sumVector = selfVector.sum(vector: vector)
        return CGPoint(from: sumVector)
    }

}

extension CGVector {

    init(pointA: CGPoint, pointB: CGPoint) {
        self.init(
            dx: pointB.x - pointA.x,
            dy: pointB.y - pointA.y
        )
    }

    var magnitude: CGFloat {
        sqrt(pow(dx, 2) + pow(dy, 2))
    }

    func sum(vector: CGVector) -> CGVector {
        return CGVector(dx: dx + vector.dx, dy: dy + vector.dy)
    }

    func multiply(scalar: CGFloat) -> CGVector {
        return CGVector(dx: dx * scalar, dy: dy * scalar)
    }

    func normalized() -> CGVector {
        return magnitude > 0 ? self / magnitude : CGVector.zero
    }

    static func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }

}
