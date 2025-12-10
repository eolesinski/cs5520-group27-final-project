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
        
        guard let email = loginView.textFieldEmail.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        guard let password = loginView.textFieldPassword.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                self?.showAlert(title: "Login Failed", message: error.localizedDescription)
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
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
