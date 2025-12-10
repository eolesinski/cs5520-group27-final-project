import UIKit
import FirebaseFirestore
import FirebaseAuth

class TodoListViewController: UITableViewController {
    
    var db = Firestore.firestore()
    var items: [ToDoItem] = []
    var currentUserName: String {
        return Auth.auth().currentUser?.displayName ?? "Anonymous"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shared List"
        
        setupHeader()
        listenToFirestore()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutTapped)),
            UIBarButtonItem(image: UIImage(systemName: "chart.pie"), style: .plain, target: self, action: #selector(didTapSummary))
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        headerView.backgroundColor = .systemBackground
        let headerLabel = UILabel(frame: headerView.bounds)
        headerLabel.text = "Group 'Need-To-Purchase' List"
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - FIRESTORE LOGIC
    
    func listenToFirestore() {
        db.collection("items").addSnapshotListener { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            self?.items = documents.map { doc in
                return ToDoItem(dictionary: doc.data())
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "What does the house need?", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Item Name" }
        alert.addTextField { $0.placeholder = "Details" }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text, !title.isEmpty,
                  let details = alert.textFields?[1].text else { return }
            
            let newItemId = UUID().uuidString
            let newItemData: [String: Any] = [
                "id": newItemId,
                "title": title,
                "details": details,
                "isPurchased": false
            ]
            
            self?.db.collection("items").document(newItemId).setData(newItemData)
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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
                cell.textLabel?.text = "\(item.title) - $\(String(format: "%.2f", price))"
            }
        } else {
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = items[indexPath.row]
            
            db.collection("items").document(itemToDelete.id).delete { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        let detailVC = TodoDetailViewController()
        
        detailVC.todoText = selectedItem.title
        detailVC.todoDetails = selectedItem.details
        detailVC.isPurchased = selectedItem.isPurchased
        
        detailVC.existingLat = selectedItem.latitude
        detailVC.existingLon = selectedItem.longitude
        
        if let price = selectedItem.purchasedPrice {
            detailVC.purchasedPrice = String(format: "%.2f", price)
        }
        
        detailVC.onClaimCompleted = { [weak self] priceText, lat, lon in
            guard let self = self else { return }
            
            var updateData: [String: Any] = [
                "isPurchased": true,
                "purchasedBy": self.currentUserName
            ]
            
            if let priceValue = Double(priceText) {
                updateData["purchasedPrice"] = priceValue
            }
            
            if let latitude = lat, let longitude = lon {
                updateData["latitude"] = latitude
                updateData["longitude"] = longitude
            }
            
            self.db.collection("items").document(selectedItem.id).updateData(updateData)
            
            self.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc func didTapSummary() {
        let summaryVC = SummaryViewController()
        summaryVC.items = self.items
        navigationController?.pushViewController(summaryVC, animated: true)
    }
    
    @objc func signOutTapped() {
        // Show confirmation alert
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            do {
                try Auth.auth().signOut()
                
                // Dismiss to the root view controller (LoginViewController)
                // This works whether user came from Login or Register
                self?.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
                self?.showAlert(title: "Sign Out Failed", message: "Could not sign out. Please try again.")
            }
        })
        
        present(alert, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
