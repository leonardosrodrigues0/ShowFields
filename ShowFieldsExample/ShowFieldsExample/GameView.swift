import UIKit
import SpriteKit

/// Game `UIView` that displays both a `SKView` with the game and
/// a `FieldView` for field visualization in the background.
class GameView: UIView {

    private lazy var scene: GameScene = {
        let scene = GameScene()
        scene.fieldSampler = FieldSampler(scene: scene, view: fieldView)
        scene.scaleMode = .aspectFit
        return scene
    }()

    private(set) lazy var skView: SKView = {
        let view = SKView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.presentScene(scene)
        return view
    }()

    private lazy var fieldView: DrawLinesView = {
        let view = DrawLinesView(frame: frame)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fieldView)
        addSubview(skView)

        NSLayoutConstraint.activate([
            fieldView.topAnchor.constraint(equalTo: topAnchor),
            fieldView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fieldView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fieldView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: topAnchor),
            skView.bottomAnchor.constraint(equalTo: bottomAnchor),
            skView.leadingAnchor.constraint(equalTo: leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
