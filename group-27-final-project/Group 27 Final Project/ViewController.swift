//
//  ViewController.swift
//  Group 27 Final Project
//
//  Created by Ethan Olesinski on 11/17/25.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        self.view = MainScreenView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let mainView = view as? MainScreenView {
            mainView.labelText.text = "Hello world!"
        }
    }

}

