//
//  QuickActionViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 03.02.24.
//

import UIKit

final class QuickActionStackView: UIStackView {
    
    // MARK: - Properties
    private let iconHolderView = UIView()
    private let iconImageView = UIImageView()
    private let actionTitleLabel = UILabel()
    private var actionHandler: (() -> Void)?
    override var tintColor: UIColor? {
        didSet {
            iconImageView.tintColor = tintColor
            actionTitleLabel.textColor = tintColor
        }
    }
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeQuickActionComponents()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Methods
    
    func configure(icon: UIImage?, title: String, action: @escaping () -> Void) {
        iconImageView.image = icon
        actionTitleLabel.text = NSLocalizedString(title, comment: "")
        self.actionHandler = action
        setupTapGesture()
    }
    
    // MARK: - Setup Functions
    
    private func initializeQuickActionComponents() {
        setupAppearance()
        setupIconHolderView()
        setupIconImageView()
        setupActionTitleLabel()
    }
    
    private func setupAppearance() {
        axis = .vertical
        spacing = 4
        alignment = .center
    }
    
    private func setupIconHolderView() {
        iconHolderView.backgroundColor = .base
        iconHolderView.layer.cornerRadius = 10
        addArrangedSubview(iconHolderView)
        constrainView(iconHolderView, size: CGSize(width: 50, height: 50))
    }
    
    private func setupIconImageView() {
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        constrainView(iconImageView, size: CGSize(width: 24, height: 24))
        iconHolderView.addSubview(iconImageView)
        centerView(iconImageView, inSuperview: iconHolderView)
    }
    
    private func setupActionTitleLabel() {
        actionTitleLabel.numberOfLines = 2
        actionTitleLabel.textAlignment = .center
        actionTitleLabel.textColor = .white
        actionTitleLabel.font = UIFont(name: "Poppins-medium", size: 12)
        addArrangedSubview(actionTitleLabel)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        actionHandler?()
    }
    
    // MARK: - Helper Functions
    
    private func constrainView(_ view: UIView, size: CGSize) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size.width),
            view.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    private func centerView(_ view: UIView, inSuperview superview: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
}
