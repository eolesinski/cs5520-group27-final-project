import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    override func loadView() {
        view = LoginView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginView = view as! LoginView
        loginView.buttonSignUp.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        loginView.buttonLogin.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    @objc func goToRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }

    @objc func loginTapped() {
        let loginView = view as! LoginView
        
        guard let email = loginView.textFieldEmail.text, !email.isEmpty,
              let password = loginView.textFieldPassword.text, !password.isEmpty else {
            print("Missing email or password")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                return
            }
            self?.goToMainApp()
        }
    }
    
    func goToMainApp() {
        DispatchQueue.main.async {
            let todoVC = TodoListViewController()
            let navController = UINavigationController(rootViewController: todoVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
}
