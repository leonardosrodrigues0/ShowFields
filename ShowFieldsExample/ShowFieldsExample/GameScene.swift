//
//  GameScene.swift
//  ShowFieldsExample
//
//  Created by Leonardo de Sousa Rodrigues on 19/09/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    static let gameSize = CGSize(width: 1600, height: 900)

    override init() {
        super.init(size: Self.gameSize)
        physicsWorld.gravity = .zero
        self.backgroundColor = .clear
    }

    private var fields: [UITouch: SKFieldNode] = [:]
    var fieldSampler: FieldSampler?

    override func didMove(to view: SKView) {
        view.isMultipleTouchEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            createField(touch: touch)
        }

        let ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: 300, y: 300)
        ball.fillColor = .red
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        ball.physicsBody?.fieldBitMask = UInt32.max
        ball.physicsBody?.charge = 3
        ball.physicsBody?.mass = 100
        addChild(ball)

//        let field = SKFieldNode.electricField()
//        field.position = CGPoint(x: 300, y: 300)
//        let node = SKShapeNode(circleOfRadius: 20)
//        node.fillColor = .red
//        node.position = CGPoint(x: 300, y: 300)
//        addChild(field)
//        addChild(node)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let field = fields[touch] {
                field.position = touch.location(in: self)
            } else {
                createField(touch: touch)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeField(touch: touch)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }

    private func createField(touch: UITouch) {
        let field = SKFieldNode.electricField()
        field.strength = 3
        field.falloff = 2
        field.position = touch.location(in: self)
        field.categoryBitMask = 16
        fields[touch] = field
        addChild(field)
    }

    private func removeField(touch: UITouch) {
        if let field = fields[touch] {
            field.removeFromParent()
            fields.removeValue(forKey: touch)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        fieldSampler?.updateLines()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
