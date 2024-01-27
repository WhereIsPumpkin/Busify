//
//  ProfileViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit

class ProfileViewController: UIViewController {
    private let nearbyReminderStack = IconLabelStackView(icon: "deskclock", title: "Set Nearby Reminder", datePickerStyle: .countDownTimer)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nearbyReminderStack)
        
        nearbyReminderStack.translatesAutoresizingMaskIntoConstraints = false
        
        nearbyReminderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nearbyReminderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}

@available(iOS 17, *)
#Preview {
    ProfileViewController()
}

