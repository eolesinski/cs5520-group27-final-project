import UIKit
import CoreLocation
import MapKit

class TodoDetailViewController: UIViewController, CLLocationManagerDelegate {

    var todoText: String = ""
    var todoDetails: String = ""
    var isPurchased: Bool = false
    var purchasedPrice: String?
    var existingLat: Double?
    var existingLon: Double?
    var onClaimCompleted: ((String, Double?, Double?) -> Void)?
    
    let locationManager = CLLocationManager()
    
    // MARK: - UI Elements
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let labelDetails: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter Price (e.g. 5.50)"
        field.borderStyle = .roundedRect
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let mapButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("📍 View Purchase Location", for: .normal)
        btn.isHidden = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let claimButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save & Claim (with GPS)", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Item Details"
        
        setupUI()
        loadData()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        claimButton.addTarget(self, action: #selector(didTapClaim), for: .touchUpInside)
        mapButton.addTarget(self, action: #selector(didTapMap), for: .touchUpInside)
    }
    
    func setupUI() {
        view.addSubview(labelTitle)
        view.addSubview(labelDetails)
        view.addSubview(priceField)
        view.addSubview(mapButton)
        view.addSubview(claimButton)
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            labelDetails.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 10),
            labelDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priceField.topAnchor.constraint(equalTo: labelDetails.bottomAnchor, constant: 30),
            priceField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priceField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mapButton.topAnchor.constraint(equalTo: priceField.bottomAnchor, constant: 20),
            mapButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            claimButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            claimButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            claimButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            claimButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func loadData() {
        labelTitle.text = todoText
        labelDetails.text = todoDetails
        priceField.text = purchasedPrice
        
        if let _ = existingLat, let _ = existingLon {
            mapButton.isHidden = false
        }
        
        if isPurchased {
            priceField.isEnabled = false
            claimButton.setTitle("Already Claimed", for: .normal)
            claimButton.isEnabled = false
            claimButton.backgroundColor = .gray
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapMap() {
        if let lat = existingLat, let lon = existingLon {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            mapItem.name = "Purchase Location"
            mapItem.openInMaps()
        }
    }
    
    @objc func didTapClaim() {
        guard let price = priceField.text, !price.isEmpty else { return }
        
        let lat = locationManager.location?.coordinate.latitude
        let lon = locationManager.location?.coordinate.longitude
        
        onClaimCompleted?(price, lat, lon)
    }
}
