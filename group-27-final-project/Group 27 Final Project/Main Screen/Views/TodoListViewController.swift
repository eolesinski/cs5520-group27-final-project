import UIKit

class TodoListViewController: UITableViewController {

    var items: [ToDoItem] = [
        ToDoItem(id: UUID().uuidString, title: "Paper Towels", details: "Buy more papertowels for the kitchen"),
        ToDoItem(id: UUID().uuidString, title: "Trash Bags", details: "Need 3.6 gallon trash bags for the bathroom"),
        ToDoItem(id: UUID().uuidString, title: "Dishwasher Pods", details: "We usually get cascade plus")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "" // Empty nav title
        
        // Create header view above table
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        headerView.backgroundColor = .systemBackground
        
        let headerLabel = UILabel()
        headerLabel.text = "Group 'Need-To-Purchase' List"
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])
        
        tableView.tableHeaderView = headerView
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let signOutButton = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped))
        let summaryButton = UIBarButtonItem(image: UIImage(systemName: "chart.pie"), style: .plain, target: self, action: #selector(didTapSummary))
        
        navigationItem.rightBarButtonItems = [signOutButton, summaryButton]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
    }
    
    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        if item.isPurchased {
            cell.textLabel?.textColor = .systemGreen
            cell.accessoryType = .checkmark
            if let price = item.purchasedPrice {
                cell.textLabel?.text = "\(item.title) - $\(price)"
            }
        } else {
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }
        
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
    
    @objc func didTapSummary() {
        let summaryVC = SummaryViewController()
        navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "What does the house need?", preferredStyle: .alert)
        
        alert.addTextField { field in
            field.placeholder = "Item Name (e.g. Eggs)"
        }
        
        alert.addTextField { field in
            field.placeholder = "Details (e.g. 1 Dozen, Organic)"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text, !title.isEmpty,
                  let details = alert.textFields?[1].text else { return }
            
            let newItem = ToDoItem(
                id: UUID().uuidString,
                title: title,
                details: details
            )
            
            self?.items.append(newItem)
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        let detailVC = TodoDetailViewController()
        
        detailVC.todoText = selectedItem.title
        detailVC.todoDetails = selectedItem.details
        
        detailVC.isPurchased = selectedItem.isPurchased
        detailVC.purchasedPrice = selectedItem.purchasedPrice
        
        detailVC.onClaimCompleted = { [weak self] price in
            self?.items[indexPath.row].isPurchased = true
            self?.items[indexPath.row].purchasedPrice = price
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
