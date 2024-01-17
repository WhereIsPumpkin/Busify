//
//  SceneDelegate.swift
//  iNet
//
//  Created by Saba Gogrichiani on 14.01.24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var signUpViewModel = AuthViewModel()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupWindow(for: windowScene)
    }
    
    func setupWindow(for windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = setupNavigationController()
        window?.makeKeyAndVisible()
    }
    
    func setupNavigationController() -> UINavigationController {
        let welcomeVC = WelcomeView(signUpViewModel: signUpViewModel) {
            self.navigateToSignUp()
        }
        let welcomeViewController = UIHostingController(rootView: welcomeVC)
        return UINavigationController(rootViewController: welcomeViewController)
    }
    
    func navigateToView<V: View>(title: String, _ view: V) {
        let viewController = UIHostingController(rootView: view)
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            viewController.title = title
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func navigateToSignUp() {
        navigateToView(title: "Register", RegisterView(signUpViewModel: signUpViewModel) {
            self.navigateToSecondStageRegister()
        })
    }
    
    func navigateToSecondStageRegister() {
        navigateToView(title: "Register", RegistrationSecondStageView(signUpViewModel: signUpViewModel) {
            self.navigateToVerification()
        })
    }
    
    func navigateToVerification() {
        navigateToView(title: "Verification", VerificationView(signUpViewModel: signUpViewModel) {
            self.navigateToVerified()
        })
    }
    
    func navigateToVerified() {
        navigateToView(title: "Congratulations", VerifiedView {
            self.navigateToLogIn()
        })
    }
    
    func navigateToLogIn() {
        let loginViewController = UIHostingController(rootView: LoginView())
        window?.rootViewController = loginViewController
    }
    
}

func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}
