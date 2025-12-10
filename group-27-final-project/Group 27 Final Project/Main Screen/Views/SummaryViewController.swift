import UIKit

class SummaryViewController: UIViewController {

    var items: [ToDoItem] = []

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Household Total"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "$0.00"
        label.font = .systemFont(ofSize: 42, weight: .bold)
        label.textColor = .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let chartContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let centerLabel: UILabel = {
        let label = UILabel()
        label.text = "Expenses"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Spending Summary"

        setupUI()
        calculateAndDisplayTotals()
    }

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(totalLabel)
        view.addSubview(chartContainer)
        chartContainer.addSubview(centerLabel)
        view.addSubview(usersStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            totalLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            chartContainer.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 30),
            chartContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartContainer.widthAnchor.constraint(equalToConstant: 200),
            chartContainer.heightAnchor.constraint(equalToConstant: 200),
            
            centerLabel.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: chartContainer.centerYAnchor),

            usersStackView.topAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: 40),
            usersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }

    // MARK: - Logic & Drawing
    
    private func calculateAndDisplayTotals() {
        var userTotals: [String: Double] = [:]
        var grandTotal: Double = 0.0
        
        for item in items {
            if item.isPurchased, let price = item.purchasedPrice, let user = item.purchasedBy {
                userTotals[user, default: 0] += price
                grandTotal += price
            }
        }
        
        totalLabel.text = "$\(String(format: "%.2f", grandTotal))"
        
        usersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if userTotals.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No purchases claimed yet."
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            usersStackView.addArrangedSubview(emptyLabel)
            
            drawPieChart(segments: [])
        } else {
            let sortedUsers = userTotals.sorted { $0.value > $1.value }
            
            var index = 0
            var segments: [(value: Double, color: UIColor)] = []
            
            for (user, amount) in sortedUsers {
                let color = getColor(for: index)
                let amountString = "$\(String(format: "%.2f", amount))"
                
         
                let row = makeUserRow(name: user, amount: amountString, color: color)
                usersStackView.addArrangedSubview(row)
                
            
                segments.append((value: amount, color: color))
                
                index += 1
            }
            
     
            drawPieChart(segments: segments)
        }
    }
    
    private func drawPieChart(segments: [(value: Double, color: UIColor)]) {
        chartContainer.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        

        let center = CGPoint(x: 100, y: 100)
        let radius: CGFloat = 80
        let lineWidth: CGFloat = 40
        
        var startAngle: CGFloat = -CGFloat.pi / 2
        
        let totalValue = segments.reduce(0) { $0 + $1.value }
        
        if totalValue == 0 {
            let bgPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let layer = CAShapeLayer()
            layer.path = bgPath.cgPath
            layer.strokeColor = UIColor.systemGray5.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = lineWidth
            chartContainer.layer.addSublayer(layer)
            return
        }
        
 
        for segment in segments {
            let percentage = segment.value / totalValue
            let endAngle = startAngle + (CGFloat(percentage) * 2 * .pi)
            
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            let sliceLayer = CAShapeLayer()
            sliceLayer.path = path.cgPath
            sliceLayer.strokeColor = segment.color.cgColor
            sliceLayer.fillColor = UIColor.clear.cgColor
            sliceLayer.lineWidth = lineWidth
            sliceLayer.strokeEnd = 1.0
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.7
            sliceLayer.add(animation, forKey: "drawStroke")
            
            chartContainer.layer.addSublayer(sliceLayer)
            
            startAngle = endAngle
        }
        
        chartContainer.addSubview(centerLabel)
    }
    
    private func getColor(for index: Int) -> UIColor {
        let colors: [UIColor] = [.systemBlue, .systemOrange, .systemPurple, .systemRed, .systemTeal, .systemGreen]
        return colors[index % colors.count]
    }

    private func makeUserRow(name: String, amount: String, color: UIColor) -> UIView {
        let rowView = UIView()
        
        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 5
        dot.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 18, weight: .medium)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = amount
        amountLabel.font = .boldSystemFont(ofSize: 18)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rowView.addSubview(dot)
        rowView.addSubview(nameLabel)
        rowView.addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            rowView.heightAnchor.constraint(equalToConstant: 30),
            
            dot.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            dot.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 10),
            dot.heightAnchor.constraint(equalToConstant: 10),
            
            nameLabel.leadingAnchor.constraint(equalTo: dot.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
        ])
        
        return rowView
    }
}
