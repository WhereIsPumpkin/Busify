//
//  ProfileViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import SwiftUI

final class ProfileViewController: UIViewController {
    // MARK: - UI Components
    private let mainStack = UIStackView()
    private let balanceStack = UIStackView()
    private let balanceTitleStack = UIStackView()
    private let appLabel = UILabel()
    private let balanceLabel = UILabel()
    private let balanceContainerView = UIView()
    private let balanceAmountLabel = UILabel()
    private let newCardPlaceholderStack = UIStackView()
    private let illustrationImage = UIImageView()
    private let addNewCardLabelStack = UIStackView()
    private let plusIcon = UIImageView()
    private let addCardLabel = UILabel()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        setupNotificationObserver()
    }
    
    // MARK: - Initial UI Setup
    private func initializeUI() {
        configureViewAppearance()
        configureMainStack()
        checkIfUserCardAvailable()
    }
    
    private func configureViewAppearance() {
        view.backgroundColor = .background
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(cardUpdatedNotificationReceived(_:)), name: .didUpdateUser, object: nil)
    }
    
    @objc private func cardUpdatedNotificationReceived(_ notification: Notification) {
        configureCardDetailsView()
    }
    
    private func configureCardDetailsView() {
        clearNewCardPlaceholderStack()
        checkIfUserCardAvailable()
    }
    
    private func checkIfUserCardAvailable() {
        if let card = UserSessionManager.shared.currentUser?.card {
            addCardViewToStack(card: card)
        } else {
            setupNewCardPlaceholderStack()
        }
    }
    
    private func clearNewCardPlaceholderStack() {
        clearPlaceholderLayout()
        removeTapGestureRecognizerFromNewCardPlaceholderStack()
    }
    
    private func clearPlaceholderLayout() {
        UIView.animate(withDuration: 0.3) {
            self.newCardPlaceholderStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            self.newCardPlaceholderStack.layer.borderWidth = 0
            self.newCardPlaceholderStack.backgroundColor = .clear
        }
    }
    
    private func removeTapGestureRecognizerFromNewCardPlaceholderStack() {
        newCardPlaceholderStack.gestureRecognizers?.forEach {
            newCardPlaceholderStack.removeGestureRecognizer($0)
        }
    }
    
    private func addCardViewToStack(card: Card) {
        let cardVC = UIHostingController(rootView: CardView(card: card))
        cardVC.view.backgroundColor = .clear
        cardVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Initially off-screen to the left
        cardVC.view.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        newCardPlaceholderStack.addArrangedSubview(cardVC.view)
        setupCardVCConstraints(cardVC)
        
        // Animate slide in from the left
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            cardVC.view.transform = .identity
        })
    }
    
    private func setupCardVCConstraints(_ cardVC: UIViewController) {
        cardVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardVC.view.leadingAnchor.constraint(equalTo: newCardPlaceholderStack.leadingAnchor),
            cardVC.view.trailingAnchor.constraint(equalTo: newCardPlaceholderStack.trailingAnchor),
            cardVC.view.topAnchor.constraint(equalTo: newCardPlaceholderStack.topAnchor),
            cardVC.view.bottomAnchor.constraint(equalTo: newCardPlaceholderStack.bottomAnchor)
        ])
    }
    
    // MARK: - Main Stack View Configuration
    private func configureMainStack() {
        addMainStackToView()
        setMainStackConstraints()
        configureMainStackAppearance()
        configureBalanceStack()
        addMainStackSubviews()
        setupMainStackCustomSpacings()
    }
    
    private func addMainStackToView() {
        view.addSubview(mainStack)
    }
    
    private func setMainStackConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureMainStackAppearance() {
        mainStack.axis = .vertical
        mainStack.spacing = 8
    }
    
    private func addMainStackSubviews() {
        mainStack.addArrangedSubview(balanceStack)
        mainStack.addArrangedSubview(newCardPlaceholderStack)
        mainStack.addArrangedSubview(UIView())
    }
    
    private func setupMainStackCustomSpacings() {
        mainStack.setCustomSpacing(24, after: balanceStack)
    }
    
    // MARK: - Balance Stack Setup
    private func configureBalanceStack() {
        configureBalanceStackAppearance()
        addBalancedStackArrangedSubviews()
        configureBalanceStackElements()
    }
    
    private func configureBalanceStackAppearance() {
        balanceStack.axis = .horizontal
        balanceStack.distribution = .fill
        balanceStack.alignment = .center
    }
    
    private func addBalancedStackArrangedSubviews() {
        balanceStack.addArrangedSubview(balanceTitleStack)
        balanceStack.addArrangedSubview(balanceContainerView)
    }
    
    private func configureBalanceStackElements() {
        configureBalanceTitleStack()
        configureBalancedContainer()
        configureBalanceAmountLabel()
    }
    
    private func configureBalancedContainer() {
        setupBalanceContainerConstraints()
        setupBalanceContainerLayer()
        addBalancedContainerArrangedSubview()
    }
    
    private func setupBalanceContainerConstraints() {
        balanceContainerView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        balanceContainerView.widthAnchor.constraint(equalToConstant: 112).isActive = true
    }
    
    private func setupBalanceContainerLayer() {
        balanceContainerView.layer.cornerRadius = 16
        balanceContainerView.layer.borderWidth = 1
        balanceContainerView.layer.borderColor = UIColor(.accent.opacity(0.2)).cgColor
    }
    
    private func addBalancedContainerArrangedSubview() {
        balanceContainerView.addSubview(balanceAmountLabel)
    }
    
    private func configureBalanceAmountLabel() {
        configureBalanceAmountLabelLayout()
        setupBalanceAmountConstraints()
    }
    
    private func configureBalanceAmountLabelLayout() {
        balanceAmountLabel.text = "₾0.00"
        balanceAmountLabel.font = UIFont(name: "Poppins-medium", size: 18)
        balanceAmountLabel.textColor = .white
    }
    
    private func setupBalanceAmountConstraints() {
        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceAmountLabel.centerXAnchor.constraint(equalTo: balanceContainerView.centerXAnchor),
            balanceAmountLabel.centerYAnchor.constraint(equalTo: balanceContainerView.centerYAnchor)
        ])
    }
    
    private func configureBalanceTitleStack() {
        configureBalanceTitleStackAppearance()
        setupBalancedTitleStackArrangedSubviews()
    }
    
    private func configureBalanceTitleStackAppearance() {
        balanceTitleStack.axis = .vertical
    }
    
    private func setupBalancedTitleStackArrangedSubviews() {
        setupAppLabel()
        setupBalanceLabel()
        
        balanceTitleStack.addArrangedSubview(appLabel)
        balanceTitleStack.addArrangedSubview(balanceLabel)
    }
    
    private func setupAppLabel() {
        appLabel.text = "App"
        appLabel.textColor = UIColor(red: 214/255, green: 208/255, blue: 208/255, alpha: 0.8)
        appLabel.font = UIFont(name: "Poppins-regular", size: 14)
    }
    
    private func setupBalanceLabel() {
        balanceLabel.text = "Balance:"
        balanceLabel.textColor = .white
        balanceLabel.font = UIFont(name: "Poppins-medium", size: 22)
    }
    
    private func setupNewCardPlaceholderStack() {
        setupNewCardPlaceholderStackLayout()
        setupNewCardPlaceholderStackMargins()
        setupCardIllustration()
        setupAddNewCardLabelStack()
        addNewCardPlaceholderStackArrangedSubviews()
        addNewCardPlaceholderTapGesture()
        setupPlaceholderConstraints()
        newCardPlaceholderStack.setCustomSpacing(36, after: illustrationImage)
    }
    
    private func setupPlaceholderConstraints() {
        newCardPlaceholderStack.translatesAutoresizingMaskIntoConstraints = false
        newCardPlaceholderStack.heightAnchor.constraint(equalToConstant: 182).isActive = true
    }
    
    private func addNewCardPlaceholderStackArrangedSubviews() {
        newCardPlaceholderStack.addArrangedSubview(illustrationImage)
        newCardPlaceholderStack.addArrangedSubview(addNewCardLabelStack)
    }
    
    private func addNewCardPlaceholderTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCardPlaceholderTapGesture))
        newCardPlaceholderStack.isUserInteractionEnabled = true
        newCardPlaceholderStack.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleCardPlaceholderTapGesture() {
        let swiftUIView = AddNewCardView() // AddNewCardView is your SwiftUI view
        let addNewCardVC = UIHostingController(rootView: swiftUIView)
        
        if let sheet = addNewCardVC.sheetPresentationController {
            let customHeight = self.view.frame.height * 0.40
            print(self.view.frame.height)
            sheet.detents = [.custom { context in customHeight }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        present(addNewCardVC, animated: true)
    }
    
    private func setupNewCardPlaceholderStackLayout() {
        newCardPlaceholderStack.axis = .vertical
        newCardPlaceholderStack.alignment = .center
        newCardPlaceholderStack.backgroundColor = UIColor(.base.opacity(0.2))
        setupCardPlaceholderLayer()
    }
    
    private func setupCardPlaceholderLayer() {
        newCardPlaceholderStack.layer.borderWidth = 1
        newCardPlaceholderStack.layer.borderColor = UIColor(.accent.opacity(0.2)).cgColor
        newCardPlaceholderStack.layer.cornerRadius = 20
    }
    
    private func setupNewCardPlaceholderStackMargins() {
        newCardPlaceholderStack.isLayoutMarginsRelativeArrangement = true
        newCardPlaceholderStack.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 28, right: 0)
    }
    
    private func setupCardIllustration() {
        configCardIllustration()
        setupCardIllustrationConstraints()
    }
    
    private func configCardIllustration() {
        illustrationImage.image = UIImage(resource: .cardIllustration)
        illustrationImage.contentMode = .scaleAspectFit
    }
    
    private func setupCardIllustrationConstraints() {
        illustrationImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            illustrationImage.widthAnchor.constraint(equalToConstant: 84),
        ])
    }
    
    private func setupAddNewCardLabelStack() {
        setupNewCardLabelStackLayout()
        setupCardLabelStackArrangedSubviews()
        addNewCardLabelStackArrangedSubviews()
    }
    
    private func setupNewCardLabelStackLayout() {
        addNewCardLabelStack.axis = .horizontal
        addNewCardLabelStack.spacing = 8
    }
    
    private func setupCardLabelStackArrangedSubviews() {
        setupPlusIcon()
        setupAddCardLabel()
    }
    
    private func addNewCardLabelStackArrangedSubviews() {
        addNewCardLabelStack.addArrangedSubview(plusIcon)
        addNewCardLabelStack.addArrangedSubview(addCardLabel)
    }
    
    private func setupPlusIcon() {
        plusIconConfig()
        plusIcon.tintColor = UIColor(resource: .alternate)
        plusIcon.translatesAutoresizingMaskIntoConstraints = false
        plusIcon.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            plusIcon.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func plusIconConfig() {
        let largeFont = UIFont.systemFont(ofSize: 24)
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .alternate])
        let configuration = UIImage.SymbolConfiguration(font: largeFont).applying(config)
        if let locationIcon = UIImage(systemName: "plus.circle.fill", withConfiguration: configuration) {
            plusIcon.image = locationIcon
        }
    }
    
    private func setupAddCardLabel() {
        addCardLabel.text = "Add new card"
        addCardLabel.textColor = .white
        addCardLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
}

@available(iOS 17, *)
#Preview {
    ProfileViewController()
}

