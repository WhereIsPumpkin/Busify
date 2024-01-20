//
//  CustomStyleButton.swift
//  iNet
//
//  Created by Saba Gogrichiani on 20.01.24.
//

import UIKit

class CustomStyledButton: UIButton {

    private var icon: UIImage?
    private var buttonText: String
    private var buttonColor: UIColor
    private var textColor: UIColor

    init(buttonText: String, buttonColor: UIColor, textColor: UIColor, icon: UIImage? = nil) {
        self.buttonText = buttonText
        self.buttonColor = buttonColor
        self.textColor = textColor
        self.icon = icon
        super.init(frame: .zero)
        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = buttonColor
        config.baseForegroundColor = textColor
        config.cornerStyle = .medium
        config.title = buttonText
        config.image = icon
        config.imagePadding = 10  // Adjust as needed
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "Poppins-Medium", size: 16)
            return outgoing
        }

        self.configuration = config
    }
}


