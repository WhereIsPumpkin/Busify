//
//  ProfileViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import SwiftUI

final class ProfileScreen: UIViewController {
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
    private let quickActionsStackView = UIStackView()
    private let fillFundsAction = QuickActionStackView()
    private let deleteCardAction = QuickActionStackView()
    private let viewModel = ProfileViewModel()
    private var isCardPresent: Bool = false
    private var cardCheckAnimation: CardCheckAnimation?
    private let logoutButton: RoundedIconButton = {
        let config = ButtonConfig(title: "logOut", systemImageName: "door.left.hand.open", action: {
            NavigationManager.shared.logout()
        })
        return RoundedIconButton(config: config)
    }()
    
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
        configureBalanceAmountLabelLayout()
        
        let cardAvailable = UserSessionManager.shared.currentUser?.card != nil
        
        if cardAvailable != isCardPresent {
            configureCardDetailsView()
            isCardPresent = cardAvailable
        }
    }
    
    private func configureCardDetailsView() {
        clearNewCardPlaceholderStack()
        checkIfUserCardAvailable()
    }
    
    private func checkIfUserCardAvailable() {
        if let card = UserSessionManager.shared.currentUser?.card {
            addCardViewToStack(card: card)
            addQuickActionsStackView()
            isCardPresent = true
        } else {
            setupNewCardPlaceholderStack()
            isCardPresent = false
            mainStack.addArrangedSubview(UIView())
        }
    }
    
    private func addQuickActionsStackView() {
        mainStack.addArrangedSubview(quickActionsStackView)
        mainStack.addArrangedSubview(UIView())
        quickActionsStackView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
        animateQuickActionsStackView()
    }
    
    private func animateQuickActionsStackView() {
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            self.quickActionsStackView.transform = .identity
        })
    }
    
    private func clearNewCardPlaceholderStack() {
        clearPlaceholderLayout()
        removeTapGestureRecognizerFromNewCardPlaceholderStack()
        removeQuickActionsStackView()
    }
    
    private func removeQuickActionsStackView() {
        if mainStack.arrangedSubviews.contains(quickActionsStackView) {
            mainStack.removeArrangedSubview(quickActionsStackView)
            quickActionsStackView.removeFromSuperview()
        }
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
        
        cardVC.view.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
        newCardPlaceholderStack.addArrangedSubview(cardVC.view)
        setupCardVCConstraints(cardVC)
        
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
        setupQuickActionsStack()
        addMainStackSubviews()
        setupMainStackCustomSpacings()
        setupLogoutButton()
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
        mainStack.distribution = .fill
        mainStack.spacing = 8
    }
    
    private func addMainStackSubviews() {
        mainStack.addArrangedSubview(balanceStack)
        mainStack.addArrangedSubview(newCardPlaceholderStack)
    }
    
    private func setupMainStackCustomSpacings() {
        mainStack.setCustomSpacing(24, after: balanceStack)
        mainStack.setCustomSpacing(20, after: newCardPlaceholderStack)
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
        balanceAmountLabel.text = "₾\(UserSessionManager.shared.currentUser?.balance ?? 0.00 / 100)"
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
        appLabel.text = NSLocalizedString("app", comment: "")
        appLabel.textColor = UIColor(red: 214/255, green: 208/255, blue: 208/255, alpha: 0.8)
        appLabel.font = UIFont(name: "Poppins-regular", size: 14)
    }
    
    private func setupBalanceLabel() {
        balanceLabel.text =  NSLocalizedString("balance", comment: "")
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
        var customHeight = 0.0
        let addNewCardVC = UIHostingController(rootView: AddNewCardView(viewModel: AddNewCardViewModel(completion: {
            self.showCardCheckAnimation()
        })))
        
        if let sheet = addNewCardVC.sheetPresentationController {
            if view.frame.height < 670 {
                customHeight = self.view.frame.height * 0.5
            } else {
                customHeight = self.view.frame.height * 0.40
            }
            sheet.detents = [.custom { context in customHeight }]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        present(addNewCardVC, animated: true)
    }
    
    private func showCardCheckAnimation() {
        DispatchQueue.main.async {
            let animationView = CardCheckAnimation()
            animationView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                animationView.removeFromSuperview()
            }
        }
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
        addCardLabel.text = NSLocalizedString("addCard", comment: "")
        addCardLabel.textColor = .white
        addCardLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    private func setupQuickActionsStack() {
        setupQuickActionStackAppearance()
        setupActionItems()
        setupQuickActionStackArrangedSubviews()
        
    }
    
    private func setupQuickActionStackAppearance() {
        quickActionsStackView.axis = .horizontal
        quickActionsStackView.distribution = .fill
        quickActionsStackView.spacing = 16
    }
    
    private func setupActionItems() {
        fillFundsAction.configure(icon: UIImage(systemName: "plus.circle"), title: "fillBalance") {
            
            let swiftUIView = FillBalanceView()
            let FillBalanceVC = UIHostingController(rootView: swiftUIView)
            
            if let sheet = FillBalanceVC.sheetPresentationController {
                var customHeight: Double = 0.0
                if self.view.frame.height < 670 {
                    customHeight = self.view.frame.height * 0.36
                } else {
                    customHeight = self.view.frame.height * 0.3
                }
                sheet.detents = [.custom { context in customHeight }]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }
            
            self.present(FillBalanceVC, animated: true)
        }
        
        fillFundsAction.icon = UIImage(named: "moneyPlus")
        
        deleteCardAction.configure(icon: UIImage(systemName: "trash.fill"), title: "deleteCard") { [weak self] in
            let alert = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                Task {
                    await self?.viewModel.deleteCard()
                }
                print("Card deletion confirmed")
            }))
            self?.present(alert, animated: true)
        }
        deleteCardAction.tintColor = .red
    }
    
    private func setupQuickActionStackArrangedSubviews() {
        quickActionsStackView.addArrangedSubview(fillFundsAction)
        quickActionsStackView.addArrangedSubview(deleteCardAction)
        quickActionsStackView.addArrangedSubview(UIView())
    }
    
    private func setupLogoutButton() {
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

@available(iOS 17, *)
#Preview {
    ProfileScreen()
}

