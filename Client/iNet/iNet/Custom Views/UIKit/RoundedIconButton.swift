//
//  RoundedIconButton.swift
//  iNet
//
//  Created by Saba Gogrichiani on 06.02.24.
//

import UIKit

struct ButtonConfig {
    let title: String
    let systemImageName: String
    let action: () -> Void
}

class RoundedIconButton: UIButton {
    
    private var action: (() -> Void)?
    
    // MARK: - Initialization
    convenience init(config: ButtonConfig) {
        self.init(frame: .zero)
        configureButton(with: config)
    }
    
    // MARK: - Configuration
    private func configureButton(with config: ButtonConfig) {
        applyBaseConfiguration()
        setTitle(NSLocalizedString(config.title, comment: ""), withCustomFont: "Poppins-medium", size: 16)
        setImage(config.systemImageName)
        addAction(for: config.action)
        setCornerRadius(20)
        setContentInsets(top: 10, leading: 24, bottom: 10, trailing: 24)
    }
    
    private func applyBaseConfiguration() {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.baseBackgroundColor = UIColor(red: 235/255, green: 50/255, blue: 35/255, alpha: 0.5)
        buttonConfig.baseForegroundColor = .white
        self.configuration = buttonConfig
    }
    
    private func setTitle(_ title: String, withCustomFont fontName: String, size: CGFloat) {
        guard let customFont = UIFont(name: fontName, size: size) else { return }
        let attributes: [NSAttributedString.Key: Any] = [.font: customFont]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    private func setImage(_ imageName: String) {
        self.configuration?.image = UIImage(systemName: imageName)
        self.configuration?.imagePlacement = .leading
        self.configuration?.imagePadding = 8
    }
    
    private func addAction(for userAction: @escaping () -> Void) {
        self.action = userAction
        addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    private func setCornerRadius(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    private func setContentInsets(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
        self.configuration?.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    // MARK: - Actions
    @objc private func buttonPressed() {
        action?()
    }
}

#Preview {
    ProfileViewController()
}
