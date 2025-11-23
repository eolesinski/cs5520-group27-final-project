//
//  RegisterViewController.swift
//  Group 27 Final Project
//
//  
//


import UIKit

class RegisterViewController: UIViewController {
    
    var registerView: RegisterView!

    override func loadView() {
        registerView = RegisterView()
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        
        // Add action
        registerView.buttonRegister.addTarget(
            self,
            action: #selector(registerTapped),
            for: .touchUpInside
        )
    }
    
    @objc func registerTapped() {
        
        let todoVC = TodoListViewController()
        let navController = UINavigationController(rootViewController: todoVC)
        
        // Replace the window’s rootViewController
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }
    }
}
