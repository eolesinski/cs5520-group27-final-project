
//
//  LoginView.swift
//  Group 27 Final Project
//
//
//

import UIKit

class LoginView: UIView {

    var titleLabel: UILabel!
    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var buttonLogin: UIButton!
    var buttonSignUp: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupTitleLabel()
        setupEmailField()
        setupPasswordField()
        setupLoginButton()
        setupSignUpButton()
        setupConstraints()
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Group Shopping List"
        titleLabel.font = .boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }

    func setupEmailField() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.autocapitalizationType = .none
        textFieldEmail.autocorrectionType = .no
        textFieldEmail.returnKeyType = .next
        textFieldEmail.textContentType = .emailAddress
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldEmail)
    }

    func setupPasswordField() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.returnKeyType = .done
        textFieldPassword.textContentType = .password
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldPassword)
    }

    func setupLoginButton() {
        buttonLogin = UIButton(type: .system)
        buttonLogin.setTitle("Log In", for: .normal)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 18)
        buttonLogin.backgroundColor = .systemBlue
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.layer.cornerRadius = 10
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonLogin)
    }

    func setupSignUpButton() {
        buttonSignUp = UIButton(type: .system)
        buttonSignUp.setTitle("Don't have an account? Sign Up", for: .normal)
        buttonSignUp.titleLabel?.font = .systemFont(ofSize: 14)
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonSignUp)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textFieldEmail.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            textFieldEmail.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldEmail.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            textFieldEmail.heightAnchor.constraint(equalToConstant: 44),

            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldPassword.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 44),

            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 32),
            buttonLogin.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonLogin.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            buttonLogin.heightAnchor.constraint(equalToConstant: 50),

            buttonSignUp.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 24),
            buttonSignUp.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
