//
//  ProfileViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 56/255, green: 59/255, blue: 63/255, alpha: 1)
        let iconLabelStackView = IconLabelStackView(icon: "timer", title: "Set Nearby Reminder", datePickerStyle: .date)
        
        iconLabelStackView.onDateSelected = { selectedValue in
                    print("Selected Value: \(selectedValue)")
                }
        
        // Add the iconLabelStackView to the view controller's view
        view.addSubview(iconLabelStackView)
        iconLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints to center the iconLabelStackView
        NSLayoutConstraint.activate([
            iconLabelStackView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40),
            iconLabelStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconLabelStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}


