import UIKit

final class ReceiveViewController: UIViewController {
    
    private enum Static {
        enum Layout {
            static let stackViewInsets = 16.0
        }
        
        enum Font {
            static let balanceFont = UIFont.systemFont(
                ofSize: 22,
                weight: UIFont.Weight.bold
            )
            
            static let addressFont = UIFont.systemFont(
                ofSize: 12,
                weight: UIFont.Weight.regular
            )
        }
    }
    
    private let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let balanceDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Static.Font.balanceFont
        label.text = "Balance"
        
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = Static.Font.balanceFont
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
        label.font = Static.Font.addressFont
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
    
    // TODO: - Remove force unwrap in future
    var viewModel: ReceiveViewModel!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        balanceLabel.text = "???"
        addressLabel.text = "Generating"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startLoading()
        viewModel.createNewAccount { [weak self, viewModel] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let account):
                    self?.addressLabel.text = account.publicKey.base58EncodedString
                case .failure(let error):
                    print("Error \(error)")
                }
            }
            try? viewModel?.getBalance { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let balance):
                        self?.balanceLabel.text = "\(balance)"
                    case .failure(let error):
                        print("Error \(error)")
                    }
                    self?.stopLoading()
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        //MARK
        
        view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
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
    
    private func startLoading() {
        indicatorView.startAnimating()
    }
    
    private func stopLoading() {
        indicatorView.stopAnimating()
    }

}


