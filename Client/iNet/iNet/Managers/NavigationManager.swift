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
    
    // MARK: - Init Process
    func setupNavigationController(in window: UIWindow?) -> UINavigationController {
        let welcomeVC = WelcomeView(signUpViewModel: authViewModel) {
            self.navigateToSignUp(in: window)
        } navigateToLogIn: {
            self.navigateToLogIn(in: window)
        }
        let welcomeViewController = UIHostingController(rootView: welcomeVC)
        return UINavigationController(rootViewController: welcomeViewController)
    }
    
    // MARK: - Log In Process
    func navigateToLogIn(in window: UIWindow?) {
        let loginView = LoginView(viewModel: authViewModel)
        let loginViewController = UIHostingController(rootView: loginView)

        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: false)
            
            navigationController.pushViewController(loginViewController, animated: true)
        }
    }
    
    // MARK: - Sign Up Process
    func navigateToSignUp(in window: UIWindow?) {
        navigateToView(title: "Register", RegisterView(viewModel: authViewModel) {
            self.navigateToSecondStageRegister(in: window)
        }, in: window)
    }
    
    func navigateToSecondStageRegister(in window: UIWindow?) {
        navigateToView(title: "Register", RegistrationSecondStageView(signUpViewModel: authViewModel) {
            self.navigateToVerification(in: window)
        }, in: window)
    }
    
    func navigateToVerification(in window: UIWindow?) {
        navigateToView(title: "Verification", VerificationView(signUpViewModel: authViewModel) {
            self.navigateToVerified(in: window)
        }, in: window)
    }
    
    func navigateToVerified(in window: UIWindow?) {
        navigateToView(title: "Congratulations", VerifiedView {
            self.navigateToLogIn(in: window)
        }, in: window)
    }
    
    func navigateToView<V: View>(title: String, _ view: V, in window: UIWindow?) {
        let viewController = UIHostingController(rootView: view)
        if let navigationController = window?.rootViewController as? UINavigationController {
            viewController.title = title
            navigationController.pushViewController(viewController, animated: true)
        }
    }
}
