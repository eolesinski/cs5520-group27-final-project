//
//  TodoDetailViewController.swift
//  Group 27 Final Project
//
//  
//


import UIKit

class TodoDetailViewController: UIViewController {

    // MARK: - Data Variables
    var todoText: String?
    var todoDetails: String?
    var isPurchased: Bool = false
    var purchasedPrice: String?
    
    var onClaimCompleted: ((String) -> Void)?

    // MARK: - UI Elements
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 18)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Price (e.g. 5.99)"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        tf.textAlignment = .center
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let claimButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Mark as Purchased", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Item Details"
        
        titleLabel.text = todoText
        detailsLabel.text = todoDetails
        
        view.addSubview(titleLabel)
        view.addSubview(detailsLabel)
        
        // CONDITIONAL UI LOGIC
        if isPurchased {
            statusLabel.text = "This item has been purchased for: $\(purchasedPrice ?? "0.00")"
            view.addSubview(statusLabel)
        } else {
            view.addSubview(priceTextField)
            view.addSubview(claimButton)
            claimButton.addTarget(self, action: #selector(didTapClaim), for: .touchUpInside)
        }
        
        setupConstraints()
    }
    
    // MARK: - Layout
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        if isPurchased {
            NSLayoutConstraint.activate([
                statusLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 40),
                statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                priceTextField.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 40),
                priceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                priceTextField.widthAnchor.constraint(equalToConstant: 200),
                
                claimButton.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 20),
                claimButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                claimButton.widthAnchor.constraint(equalToConstant: 220),
                claimButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapClaim() {
        guard let priceText = priceTextField.text, !priceText.isEmpty else { return }
        onClaimCompleted?(priceText)
        navigationController?.popViewController(animated: true)
    }
}
