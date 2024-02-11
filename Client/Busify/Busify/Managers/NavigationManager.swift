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
        let welcomeVC = WelcomeScreen(signUpViewModel: authViewModel)
        let welcomeViewController = UIHostingController(rootView: welcomeVC)
        return UINavigationController(rootViewController: welcomeViewController)
    }
    
    // MARK: - Log In Process
    func navigateToLogIn() {
        let loginView = LoginScreen(viewModel: authViewModel)
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
    
    // MARK: - Sign Up Process
    func navigateToSignUp() {
        let signUpView = RegisterScreen(viewModel: authViewModel)
        navigateToViewController(UIHostingController(rootView: signUpView))
    }
    
    func navigateToVerification() {
        let verificationView = VerificationScreen(signUpViewModel: authViewModel)
        navigateToViewController(UIHostingController(rootView: verificationView))
    }
    
    func navigateToVerified() {
        let verifiedView = VerifiedScreen()
        navigateToViewController(UIHostingController(rootView: verifiedView))
    }
    
    func navigateToBusViewController() {
        navigateToViewController(BusStopSearchScreen())
    }
    
    func navigateToBusStopDetailsPage(arrivalTimes: ArrivalTimesResponse?, stopId: String) {
        let busStopDetailsPage = BusStopDetailsScreen(arrivalTimes: arrivalTimes, stopId: stopId)
        
        if let tabBarController = window?.rootViewController as? UITabBarController,
           let navigationController = tabBarController.selectedViewController as? UINavigationController {
            navigationController.pushViewController(busStopDetailsPage, animated: true)
        } else {
            print("No suitable navigation controller found")
        }
    }
    
    // MARK: - Generic Navigation Helper
    private func navigateToViewController(_ viewController: UIViewController) {
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - Log Out Process
    func logout() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        
        navigateToInitialScreen()
    }
}
