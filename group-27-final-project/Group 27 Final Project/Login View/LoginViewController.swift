import UIKit

class LoginViewController: UIViewController {

    override func loadView() {
        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginView = view as! LoginView
        
        // Go to Register screen
        loginView.buttonSignUp.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        
        // Go to To-Do list after login
        loginView.buttonLogin.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    @objc func goToRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    @objc func loginTapped() {
        let todoVC = TodoListViewController()
        let navController = UINavigationController(rootViewController: todoVC)
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }
    }
}
