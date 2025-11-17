//
//  MainScreenView.swift
//  Group 27 Final Project
//
//
//

import UIKit

class MainScreenView: UIView {

    var labelText: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        setupLabelText()
        setupConstraints()
    }

    func setupLabelText() {
        labelText = UILabel()
        labelText.font = .boldSystemFont(ofSize: 18)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelText)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            labelText.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            labelText.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),

        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
