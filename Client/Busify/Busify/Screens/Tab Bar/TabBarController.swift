//
//  MainScreenViewController.swift
//  Busify
//
//  Created by Saba Gogrichiani on 18.01.24.
//

import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBarViews()
        setupTabBarColors()
    }
    
    // MARK: - Setup Tab Bar Views
    private func setUpTabBarViews() {
        let homeScreenVC = createHomeScreenVC()
        let profileVC = createProfileVC()
        let liveMapVC = createLiveMapVC()
        let serviceVC = createServicesVC()
        
        setViewControllers([homeScreenVC, serviceVC, liveMapVC, profileVC ], animated: true)
    }
    
    // MARK: - Create TabBarItem View Controllers
    private func createHomeScreenVC() -> UINavigationController {
        let homeVC = UIHostingController(rootView: HomeScreen())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.title = NSLocalizedString("home", comment: "")
        homeVC.navigationItem.title = ""
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.hidesBarsOnSwipe = true
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    private func createServicesVC() -> UINavigationController {
        let busStopVC = UINavigationController(rootViewController: BusStopSearchScreen())
        busStopVC.tabBarItem = UITabBarItem(title: NSLocalizedString("busStop", comment: ""), image: UIImage(resource: .busStopIconTest), selectedImage: nil)
        return busStopVC
    }
    
    private func createLiveMapVC() -> UINavigationController {
        let liveMapVC = UINavigationController(rootViewController: LiveMapScreen())
        liveMapVC.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
        liveMapVC.title = NSLocalizedString("liveMap", comment: "")
        return liveMapVC
    }
    
    private func createProfileVC() -> UINavigationController {
        let profileVC = UINavigationController(rootViewController: ProfileScreen())
        profileVC.tabBarItem.image = UIImage(systemName: "circle.grid.2x2.fill")
        profileVC.title = NSLocalizedString("services", comment: "")
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
