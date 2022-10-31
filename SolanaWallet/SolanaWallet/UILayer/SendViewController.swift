import UIKit

final class SendViewController: UIViewController {
    
    private enum Static {
        enum Layout {
            static let stackViewInsets = 16.0
            static let stackViewSpacing = 8.0
        }
        
        enum Font {
            static let labelDescriptionFont = UIFont.systemFont(
                ofSize: 14,
                weight: UIFont.Weight.bold
            )
            
            static let textfieldFont = UIFont.systemFont(
                ofSize: 14,
                weight: UIFont.Weight.regular
            )
        }
    }
    
    private let sendAddressDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Static.Font.labelDescriptionFont
        label.textAlignment = .center
        label.text = "Address to send"
        return label
    }()
    
    private let sendAddressTextField: UITextField = {
        let textField = UITextField()
        textField.font = Static.Font.textfieldFont
        textField.textAlignment = .center
        textField.placeholder = "Type address here"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = Static.Font.labelDescriptionFont
        label.textAlignment = .center
        label.text = "Amount to send"
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.font = Static.Font.textfieldFont
        textField.textAlignment = .center
        textField.placeholder = "Type amount here"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendAddressStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                sendAddressDescriptionLabel,
                sendAddressTextField,
                amountLabel,
                amountTextField,
                sendButton
            ]
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Static.Layout.stackViewSpacing
        return stackView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(sendAddressStackView)
        
        NSLayoutConstraint.activate([
            sendAddressStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Static.Layout.stackViewInsets
            ),
            sendAddressStackView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Static.Layout.stackViewInsets
            ),
            sendAddressStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc
    private func sendButtonTapped() {
        print("Button tapped")
    }
    
}
