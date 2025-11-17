//
//  LoginView.swift
//  Group 27 Final Project
//
//  
//


import UIKit

class LoginView: UIView {

    var textFieldEmail: UITextField!
    var textFieldPassword: UITextField!
    var buttonLogin: UIButton!
    var buttonSignUp: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        setupEmailField()
        setupPasswordField()
        setupLoginButton()
        setupSignUpButton()
        setupConstraints()
    }

    func setupEmailField() {
        textFieldEmail = UITextField()
        textFieldEmail.placeholder = "Email"
        textFieldEmail.borderStyle = .roundedRect
        textFieldEmail.keyboardType = .emailAddress
        textFieldEmail.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldEmail)
    }

    func setupPasswordField() {
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "Password"
        textFieldPassword.borderStyle = .roundedRect
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldPassword)
    }

    func setupLoginButton() {
        buttonLogin = UIButton(type: .system)
        buttonLogin.setTitle("Log In", for: .normal)
        buttonLogin.titleLabel?.font = .boldSystemFont(ofSize: 16)
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
            textFieldEmail.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 80),
            textFieldEmail.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldEmail.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.bottomAnchor, constant: 16),
            textFieldPassword.centerXAnchor.constraint(equalTo: centerXAnchor),
            textFieldPassword.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 24),
            buttonLogin.centerXAnchor.constraint(equalTo: centerXAnchor),

            buttonSignUp.topAnchor.constraint(equalTo: buttonLogin.bottomAnchor, constant: 24),
            buttonSignUp.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
