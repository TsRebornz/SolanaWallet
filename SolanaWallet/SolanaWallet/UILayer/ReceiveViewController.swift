import UIKit

final class ReceiveViewController: UIViewController {
    
    private enum Static {
        enum Layout {
            static let stackViewInsets = 16.0
        }
    }
    
    private let balanceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight.bold
        )
        label.text = "Balance"
        
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 22,
            weight: UIFont.Weight.regular
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
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(
            ofSize: 14,
            weight: UIFont.Weight.regular
        )
        label.textAlignment = .center
        
        return label
    }()
    
    private let copyAddressButton: UIButton = {
        let button = UIButton()
        let copyImage = UIImage(systemName: "doc.on.doc")
        button.setImage(copyImage, for: .normal)
        button.addTarget(self, action: #selector(copyAddressButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(copyAddressButton)
        
        return stackView
    }()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        balanceLabel.text = "1000"
        addressLabel.text = "1xfdfafjeojo3409jlx09j0j3lkjdasjfasdlf"
        
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        // Balance
        view.addSubview(balanceStackView)
        
        NSLayoutConstraint.activate([
            balanceStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Static.Layout.stackViewInsets
            ),
            balanceStackView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Static.Layout.stackViewInsets
            ),
            balanceStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Static.Layout.stackViewInsets
            )
        ])
        
        // Address
        
        view.addSubview(addressStackView)
        
        NSLayoutConstraint.activate([
            addressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Static.Layout.stackViewInsets),
            addressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Static.Layout.stackViewInsets),
            addressStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc
    private func copyAddressButtonTapped() {
        UIPasteboard.general.string = addressLabel.text
    }

}


