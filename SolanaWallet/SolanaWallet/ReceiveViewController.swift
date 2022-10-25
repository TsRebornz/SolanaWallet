import UIKit



final class ReceiveViewController: UIViewController {
    
    private enum Static {
        enum Layout {
            static let balanceStackViewInsets = 6.0
        }
    }
    
    private let balanceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight(rawValue: 1000)
        )
        label.text = "Balance"
        
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight(rawValue: 300)
        )
        return label
    }()
    
    private lazy var balanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(balanceDescriptionLabel)
        stackView.addArrangedSubview(balanceLabel)
        
        stackView.alignment = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        balanceLabel.text = "1000"
        
    }
    
    private func setupUI() {
        view.addSubview(balanceStackView)
        
        NSLayoutConstraint.activate([
            balanceStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Static.Layout.balanceStackViewInsets
            ),
            balanceStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Static.Layout.balanceStackViewInsets
            ),
            balanceStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Static.Layout.balanceStackViewInsets
            )
        ])
        
    }

}


