import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view = GameView(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
    }

}
