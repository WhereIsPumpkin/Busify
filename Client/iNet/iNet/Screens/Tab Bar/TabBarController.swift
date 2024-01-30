//
//  MainScreenViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 18.01.24.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
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
        let homeVC = UIHostingController(rootView: HomeView())
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        homeVC.title = "Home"
        homeVC.navigationItem.title = ""
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.hidesBarsOnSwipe = true
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    private func createServicesVC() -> UINavigationController {
        let busStopVC = UINavigationController(rootViewController: BusStopSearchViewController())
        busStopVC.tabBarItem = UITabBarItem(title: "Bus Stop", image: UIImage(resource: .busStopIconTest), selectedImage: nil)
        return busStopVC
    }
    
    private func createLiveMapVC() -> UINavigationController {
        let liveMapVC = UINavigationController(rootViewController: LiveMapViewController())
        liveMapVC.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
        liveMapVC.title = "Live Map"
        return liveMapVC
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
