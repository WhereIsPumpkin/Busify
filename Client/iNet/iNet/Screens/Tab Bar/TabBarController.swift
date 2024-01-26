//
//  MainScreenViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 18.01.24.
//

import UIKit

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
        let busStopVC = UINavigationController(rootViewController: BusStopSearchViewController())
        let originalTabBarImage = UIImage(named: "tabBusStop")
        let tabBarImage = resizeImage(image: originalTabBarImage, targetSize: CGSize(width: 30, height: 30))
        busStopVC.tabBarItem = UITabBarItem(title: "Bus Stop", image: tabBarImage, selectedImage: nil)
        return busStopVC
    }
    
    private func createWalletVC() -> UINavigationController {
        let walletVC = UINavigationController(rootViewController: LiveMapViewController())
        walletVC.tabBarItem.image = UIImage(systemName: "mappin.and.ellipse")
        walletVC.title = "Live Map"
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

// MARK: - Extension

extension TabBarController {
    private func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else {
            return nil
        }

        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
