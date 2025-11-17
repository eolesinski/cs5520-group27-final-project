//
//  TodoDetailViewController.swift
//  Group 27 Final Project
//
//  
//


import UIKit

class TodoDetailViewController: UIViewController {

    var todoText: String?
    var todoDetails: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "To-Do Item"

        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.text = todoText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let detailsLabel = UILabel()
        detailsLabel.numberOfLines = 0
        detailsLabel.textAlignment = .center
        detailsLabel.textColor = .darkGray
        detailsLabel.text = todoDetails
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(detailsLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
