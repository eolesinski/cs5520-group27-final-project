//
//  LoginViewController.swift
//  Group 27 Final Project
//
//  
//


import UIKit

class LoginViewController: UIViewController {

    override func loadView() {
        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginView = view as! LoginView
        loginView.buttonSignUp.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
    }

    @objc func goToRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}
