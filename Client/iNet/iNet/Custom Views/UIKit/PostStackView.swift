//
//  PostStackView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit

class PostStackView: UIStackView {
    
    private let profileImage = UIImageView()
    private let postDetails = UIStackView()
    private let nameWrapper = UIStackView()
    private let nameLabel = UILabel()
    private let verifiedIcon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    private let postText = UILabel()
    private let iconStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPostStack()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPostStack() {
        axis = .horizontal
        alignment = .top
        spacing = 8
        addArrangedSubview(profileImage)
        addArrangedSubview(postDetails)
        
        setupImageView()
        setupPostDetails()
    }
    
    private func setupPostDetails() {
        postDetails.axis = .vertical
        postDetails.alignment = .leading
        
        postDetails.addArrangedSubview(nameWrapper)
        postDetails.addArrangedSubview(postText)
        postDetails.addArrangedSubview(iconStack)
        
        postDetails.setCustomSpacing(12, after: postText)
        
        setupNameWrapper()
        setupPostText()
        setupIconStack()
    }
    
    private func setupImageView() {
        profileImage.image = UIImage(named: "avatar")
        profileImage.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = 55 / 2
        profileImage.clipsToBounds = true
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.widthAnchor.constraint(equalToConstant: 55).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    private func setupNameWrapper() {
        nameWrapper.axis = .horizontal
        nameWrapper.alignment = .center
        nameWrapper.spacing = 4
        
        nameWrapper.addArrangedSubview(nameLabel)
        nameWrapper.addArrangedSubview(verifiedIcon)
        
        let spacer = UIView()
        nameWrapper.addArrangedSubview(spacer)
        
        setupName()
        setupVerifiedIcon()
    }
    
    private func setupName() {
        nameLabel.text = "John Doe"
        nameLabel.textColor = .black
        nameLabel.font = UIFont(name: "Poppins-semibold", size: 14)
    }
    
    private func setupVerifiedIcon() {
        verifiedIcon.tintColor = UIColor(named: "mainColor")
        verifiedIcon.contentMode = .scaleAspectFit
        verifiedIcon.widthAnchor.constraint(equalToConstant: 14).isActive = true
    }
    
    private func setupPostText() {
        postText.text = "Y’all ready for this next"
        postText.font = UIFont(name: "Poppins", size: 16)
        postText.textColor = .black
        postText.numberOfLines = 0  // Allow multiple lines
          postText.lineBreakMode = .byWordWrapping  // Break
    }
    
    private func setupIconStack() {
        iconStack.axis = .horizontal
        iconStack.alignment = .center
        iconStack.distribution = .equalSpacing
        iconStack.spacing = 40

        let heartIcon = UIImageView(image: UIImage(systemName: "heart"))
        let messageIcon = UIImageView(image: UIImage(systemName: "message"))
        let bookmarkIcon = UIImageView(image: UIImage(systemName: "bookmark"))

        [heartIcon, messageIcon, bookmarkIcon].forEach { icon in
            icon.contentMode = .scaleAspectFit
            icon.tintColor = .gray
            iconStack.addArrangedSubview(icon)
        }

        postDetails.addArrangedSubview(iconStack)
        
    }

}



