//
//  MainScreenViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 18.01.24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarViews()
        setupTabBarColors()
    }
    
    // MARK: - Setup Tab Bar Views
    private func setUpTabBarViews() {
        let homeScreenVC = createHomeScreenVC()
        let profileVC = createProfileVC()
        let walletVC = createWalletVC()

        setViewControllers([homeScreenVC, walletVC, profileVC ], animated: true)
    }
    
    // MARK: - Create TabBarItem View Controllers
    private func createHomeScreenVC() -> UINavigationController {
        let homeVC = UINavigationController(rootViewController: HomeScreenViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.title = "Home"
        return homeVC
    }
    
    private func createWalletVC() -> UINavigationController {
        let walletVC = UINavigationController(rootViewController: WalletViewController())
        walletVC.tabBarItem.image = UIImage(systemName: "wallet.pass")
        walletVC.title = "Wallet"
        return walletVC
    }
    
    private func createProfileVC() -> UINavigationController {
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        profileVC.title = "Profile"
        return profileVC
    }

    private func setupTabBarColors() {
        tabBar.tintColor = UIColor(named: "mainColorz")
        tabBar.unselectedItemTintColor = UIColor.gray
        createTabBarBackgroundColor()
    }
    
    private func createTabBarBackgroundColor() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }

}
