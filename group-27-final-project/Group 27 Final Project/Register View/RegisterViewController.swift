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
        
        guard let name = registerView.textFieldName.text, !name.isEmpty,
              let email = registerView.textFieldEmail.text, !email.isEmpty,
              let password = registerView.textFieldPassword.text, !password.isEmpty else {
            print("Missing information")
            return
        }
        
    
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            if let changeRequest = result?.user.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                    if let error = error {
                        print("Error saving name: \(error.localizedDescription)")
                    }
                    
                    self.goToMainApp()
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
}
