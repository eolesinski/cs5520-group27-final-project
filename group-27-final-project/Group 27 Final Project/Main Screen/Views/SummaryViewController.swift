//
//  SummaryViewController.swift
//  Group 27 Final Project
//
//  Created by Kaden Casanave on 11/24/25.
//

import UIKit

class SummaryViewController: UIViewController {

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Household Total"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "$125.50" // Placeholder data
        label.font = .systemFont(ofSize: 42, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chartContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 100
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let chartLabel: UILabel = {
        let label = UILabel()
        label.text = "Chart\nPlaceholder"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Spending Summary"

        setupUI()
        setupMockData()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(totalLabel)
        view.addSubview(chartContainer)
        chartContainer.addSubview(chartLabel)
        view.addSubview(usersStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            totalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chartContainer.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 30),
            chartContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartContainer.widthAnchor.constraint(equalToConstant: 200),
            chartContainer.heightAnchor.constraint(equalToConstant: 200),
            
            chartLabel.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            chartLabel.centerYAnchor.constraint(equalTo: chartContainer.centerYAnchor),

            usersStackView.topAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: 40),
            usersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }

    // MARK: - Data Population
    
    private func setupMockData() {
        let mockUsers = [
            ("Alice", "$50.00", UIColor.systemBlue),
            ("Bob", "$25.50", UIColor.systemOrange),
            ("Charlie", "$50.00", UIColor.systemPurple)
        ]

        for user in mockUsers {
            let row = makeUserRow(name: user.0, amount: user.1, color: user.2)
            usersStackView.addArrangedSubview(row)
        }
    }

    private func makeUserRow(name: String, amount: String, color: UIColor) -> UIView {
        let rowView = UIView()
        
        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 5
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.font = .boldSystemFont(ofSize: 18)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rowView.addSubview(dot)
        rowView.addSubview(nameLabel)
        rowView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            rowView.heightAnchor.constraint(equalToConstant: 30),
            
            dot.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            dot.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 10),
            dot.heightAnchor.constraint(equalToConstant: 10),
            
            nameLabel.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
        ])
        
        return rowView
    }
}
