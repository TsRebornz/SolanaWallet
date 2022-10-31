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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        let refreshControll = UIRefreshControl()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        refreshControll.addTarget(self, action: #selector(indicatorPulled), for: .valueChanged)
        scrollView.refreshControl = refreshControll
        return scrollView
    }()
    
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
    
    private var balanceTopAnchorConstraint: NSLayoutConstraint?
    
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
            self?.updateBalance(useIndicator: true, onFinish: {})
        }
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        // Scroll view
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Indicator view
        
        view.addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Balance
        scrollView.addSubview(balanceStackView)
        
        let topAnchorContraint = balanceStackView.topAnchor.constraint(
            equalTo: scrollView.safeAreaLayoutGuide.topAnchor,
            constant: Static.Layout.stackViewInsets
        )
        topAnchorContraint.isActive = true
        balanceTopAnchorConstraint = topAnchorContraint
        
        NSLayoutConstraint.activate([
            balanceStackView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: Static.Layout.stackViewInsets
            ),
            
            balanceStackView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -Static.Layout.stackViewInsets
            )
        ])
        
        // Address
        
        scrollView.addSubview(addressStackView)
        
        NSLayoutConstraint.activate([
            addressStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Static.Layout.stackViewInsets),
            addressStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Static.Layout.stackViewInsets),
            addressStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
    }
    
    private func updateBalance(useIndicator: Bool = false, onFinish: @escaping () -> Void) {
        if useIndicator {
            startLoading()
        }
        try? viewModel?.getBalance { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let balance):
                    self?.balanceLabel.text = "\(balance)"
                case .failure(let error):
                    print("Error \(error)")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if useIndicator {
                        self?.stopLoading()
                    }
                    onFinish()
                })
            }
        }
    }
    
    @objc
    private func copyAddressButtonTapped() {
        UIPasteboard.general.string = addressLabel.text
    }
    
    @objc
    private func indicatorPulled() {
        updateBalance(onFinish: {
            self.scrollView.refreshControl?.endRefreshing()
        })
    }
    
    private func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.balanceTopAnchorConstraint?.constant = 40
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
            self?.indicatorView.startAnimating()
        }
        
    }
    
    private func stopLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.indicatorView.stopAnimating()
            self.balanceTopAnchorConstraint?.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

}


