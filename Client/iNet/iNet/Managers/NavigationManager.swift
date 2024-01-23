//
//  NavigationManager.swift
//  iNet
//
//  Created by Saba Gogrichiani on 18.01.24.
//

import SwiftUI

final class NavigationManager {
    // MARK: - Properties
    static let shared = NavigationManager()
    var authViewModel = AuthViewModel()
    var window: UIWindow?
    
    private init() {}
    
    // MARK: - Init
    init(window: UIWindow?) {
        self.window = window
    }
    
    func navigateToInitialScreen() {
        if UserDefaults.standard.string(forKey: "userToken") != nil {
            navigateToMainViewScreen()
        } else {
            let navigationController = setupNavigationController()
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    func setupNavigationController() -> UINavigationController {
        let welcomeVC = WelcomeView(signUpViewModel: authViewModel)
        let welcomeViewController = UIHostingController(rootView: welcomeVC)
        return UINavigationController(rootViewController: welcomeViewController)
    }
    
    // MARK: - Log In Process
    func navigateToLogIn() {
        let loginView = LoginView(viewModel: authViewModel)
        let loginViewController = UIHostingController(rootView: loginView)
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
            navigationController.pushViewController(loginViewController, animated: true)
        }
    }
    
    func navigateToMainViewScreen() {
        let mainScreenViewController = TabBarController()
        window?.rootViewController = mainScreenViewController
        window?.makeKeyAndVisible()
    }
    
    func createServicesVC() -> UINavigationController {
        let servicesVC = ServicesViewController() // Assuming ServicesViewController is already defined
        let navigationVC = UINavigationController(rootViewController: servicesVC)
        navigationVC.tabBarItem = UITabBarItem(title: "Services", image: UIImage(systemName: "square.grid.2x2.fill"), tag: 0)
        return navigationVC
    }
    
    // MARK: - Sign Up Process
    func navigateToSignUp() {
        let signUpView = RegisterView(viewModel: authViewModel)
        navigateToViewController(UIHostingController(rootView: signUpView))
    }
    
    func navigateToSecondStageRegister() {
        let secondStageView = RegistrationSecondStageView(signUpViewModel: authViewModel)
        navigateToViewController(UIHostingController(rootView: secondStageView))
    }
    
    func navigateToVerification() {
        let verificationView = VerificationView(signUpViewModel: authViewModel)
        navigateToViewController(UIHostingController(rootView: verificationView))
    }
    
    func navigateToVerified() {
        let verifiedView = VerifiedView()
        navigateToViewController(UIHostingController(rootView: verifiedView))
    }
    
    func navigateToChatBot() {
        let chatBotView = UIHostingController(rootView: ChatDetailView())
        navigateToViewController(chatBotView)
    }
    
    func navigateToBusViewController() {
        print("12")
        navigateToViewController(BusScheduleViewController())
    }
    
    func navigateToChatBotViewController() {
        let chatBotViewController = UIHostingController(rootView: ChatDetailView())
        navigateToViewController(chatBotViewController)
    }
    
    // MARK: - Generic Navigation Helper
    private func navigateToViewController(_ viewController: UIViewController) {
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
