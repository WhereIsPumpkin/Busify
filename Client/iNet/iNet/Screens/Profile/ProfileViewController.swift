//
//  ProfileViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Properties
    private let mainStack = UIStackView()
    private let balanceStack = UIStackView()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
    
    // MARK: - Initialization
    private func initializeUI() {
        configureViewAppearance()
        configureMainStack()
    }
    
    private func configureViewAppearance() {
        view.backgroundColor = .background
    }
    
    private func configureMainStack() {
        addMainStackToView()
        setMainStackConstraints()
        configureMainStackAppearance()
    }
    
    private func addMainStackToView() {
        view.addSubview(mainStack)
    }
    
    private func setMainStackConstraints() {
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func configureMainStackAppearance() {
        mainStack.backgroundColor = .gray
        mainStack.axis = .vertical
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(horizontal: 20, vertical: 8)
    }
}

@available(iOS 17, *)
#Preview {
    ProfileViewController()
}


