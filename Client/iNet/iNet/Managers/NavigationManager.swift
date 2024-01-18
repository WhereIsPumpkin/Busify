//
//  NavigationManager.swift
//  iNet
//
//  Created by Saba Gogrichiani on 18.01.24.
//

import SwiftUI

final class NavigationManager {
    // MARK: - Properties
    var authViewModel = AuthViewModel()
    var window: UIWindow?
    
    // MARK: - Init
    init(window: UIWindow?) {
        self.window = window
    }
    
    func setupNavigationController() -> UINavigationController {
        let welcomeVC = WelcomeView(signUpViewModel: authViewModel) {
            self.navigateToSignUp()
        } navigateToLogIn: {
            self.navigateToLogIn()
        }
        let welcomeViewController = UIHostingController(rootView: welcomeVC)
        return UINavigationController(rootViewController: welcomeViewController)
    }
    
    // MARK: - Log In Process
    func navigateToLogIn() {
        let loginView = LoginView(viewModel: authViewModel, navigateToHomeScreen: {
            self.navigateToMainViewScreen()
        })
        let loginViewController = UIHostingController(rootView: loginView)
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
            
            navigationController.pushViewController(loginViewController, animated: true)
        }
    }
    
    func navigateToMainViewScreen() {
        let mainScreenViewController = MainScreenViewController()
        
        window?.rootViewController = mainScreenViewController
        window?.makeKeyAndVisible()
    }
    
    
    // MARK: - Sign Up Process
    func navigateToSignUp() {
        let signUpView = RegisterView(viewModel: authViewModel) {
            self.navigateToSecondStageRegister()
        }
        navigateToViewController(UIHostingController(rootView: signUpView))
    }
    
    func navigateToSecondStageRegister() {
        let secondStageView = RegistrationSecondStageView(signUpViewModel: authViewModel) {
            self.navigateToVerification()
        }
        navigateToViewController(UIHostingController(rootView: secondStageView))
    }
    
    func navigateToVerification() {
        let verificationView = VerificationView(signUpViewModel: authViewModel) {
            self.navigateToVerified()
        }
        navigateToViewController(UIHostingController(rootView: verificationView))
    }
    
    func navigateToVerified() {
        let verifiedView = VerifiedView {
            self.navigateToLogIn()
        }
        navigateToViewController(UIHostingController(rootView: verifiedView))
    }
    
    // MARK: - Generic Navigation Helper
    private func navigateToViewController(_ viewController: UIViewController) {
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
}
