//
//  ProfileViewController.swift
//  Group 27 Final Project
//
//
//

import UIKit

class ProfileViewController: UIViewController {
    var name: String?
    var email: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Profile"

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Name: \(name ?? "")\nEmail: \(email ?? "")"
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
