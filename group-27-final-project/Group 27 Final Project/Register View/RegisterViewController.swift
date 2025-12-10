import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    override func loadView() {
        view = RegisterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let registerView = view as! RegisterView
        registerView.buttonRegister.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }

    @objc func registerTapped() {
        let registerView = view as! RegisterView
        
        guard let name = registerView.textFieldName.text, !name.isEmpty else {
            showAlert(title: "Missing Name", message: "Please enter your name.")
            return
        }
        
        guard let email = registerView.textFieldEmail.text, !email.isEmpty else {
            showAlert(title: "Missing Email", message: "Please enter your email address.")
            return
        }
        
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        guard let password = registerView.textFieldPassword.text, !password.isEmpty else {
            showAlert(title: "Missing Password", message: "Please enter your password.")
            return
        }
        
        // Optional: Add password strength validation
        guard password.count >= 6 else {
            showAlert(title: "Weak Password", message: "Password must be at least 6 characters long.")
            return
        }
    
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                self?.showAlert(title: "Registration Failed", message: error.localizedDescription)
                return
            }
            
            if let changeRequest = result?.user.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error saving name: \(error.localizedDescription)")
                        self?.showAlert(title: "Error", message: "Account created but failed to save name: \(error.localizedDescription)")
                        return
                    }
                    
                    self?.goToMainApp()
                }
            }
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
