//
//  ViewController.swift
//  ShowFieldsExample
//
//  Created by Leonardo de Sousa Rodrigues on 19/09/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view = GameView(frame: UIScreen.main.bounds)
        view.backgroundColor = .clear
    }

}
