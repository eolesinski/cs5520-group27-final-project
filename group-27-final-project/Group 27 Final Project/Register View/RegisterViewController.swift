//
//  RegisterViewController.swift
//  Group 27 Final Project
//
//  
//


import UIKit

class RegisterViewController: UIViewController {

    override func loadView() {
        view = RegisterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
    }
}
