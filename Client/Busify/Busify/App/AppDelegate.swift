//
//  AppDelegate.swift
//  Busify
//
//  Created by Saba Gogrichiani on 14.01.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupBarAppearance()
        NotificationManager.shared.checkForPermission()
        fetchUser()
        return true
    }
    
    private func setupBarAppearance() {
        UINavigationBar.appearance().tintColor = UIColor(resource: .accent)
        let backImage = UIImage(systemName: "chevron.backward")
        let barAppearance = UINavigationBarAppearance()
        barAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        barAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        UINavigationBar.appearance().standardAppearance = barAppearance
    }
    
    private func fetchUser() {
        Task {
            let _ = await UserSessionManager.shared.fetchUserInfo()
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

