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
        let serviceVC = createServicesVC()

        setViewControllers([homeScreenVC, serviceVC, walletVC, profileVC ], animated: true)
    }
    
    // MARK: - Create TabBarItem View Controllers
    private func createHomeScreenVC() -> UINavigationController {
        let homeVC = UINavigationController(rootViewController: HomeScreenViewController())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.title = "Home"
        return homeVC
    }
    
    private func createServicesVC() -> UINavigationController {
        let servicesVC = UINavigationController(rootViewController: ServicesViewController())
        servicesVC.tabBarItem = UITabBarItem(title: "Services", image: UIImage(systemName: "square.grid.2x2.fill"), tag: 0)
        return servicesVC
    }

    
    private func createWalletVC() -> UINavigationController {
        let walletVC = UINavigationController(rootViewController: WalletViewController())
        walletVC.tabBarItem.image = UIImage(systemName: "dollarsign.circle.fill")
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
        tabBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        createTabBarBackgroundColor()
    }
    
    private func createTabBarBackgroundColor() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(resource: .base)
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
    }

}
