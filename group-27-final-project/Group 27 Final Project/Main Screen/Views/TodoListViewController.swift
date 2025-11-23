import UIKit

class TodoListViewController: UITableViewController {

    var items: [ToDoItem] = [
        ToDoItem(id: UUID().uuidString, title: "Buy groceries", details: "Get milk, eggs, and bread"),
        ToDoItem(id: UUID().uuidString, title: "Finish project", details: "Complete final project report"),
        ToDoItem(id: UUID().uuidString, title: "Text a friend", details: "Check in with Alex")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "To-Do List"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Add Sign Out button to top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .plain,
            target: self,
            action: #selector(signOutTapped)
        )
    }
    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }

    // MARK: - Sign Out Action

    @objc func signOutTapped() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = navController
        }
    }
}
