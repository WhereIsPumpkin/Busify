//
//  ServicesCollectionViewCell.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit

class ServicesCollectionViewCell: UICollectionViewCell {
    
    let stackView = UIStackView()
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with type: ServiceType) {
        titleLabel.text = type.title
        iconImageView.image = UIImage(systemName: type.iconName)
    }
    
    private func setup() {
        clipsToBounds = true
        setupLayer()
        backgroundColor = UIColor(displayP3Red: 0.44, green: 0.44, blue: 0.44, alpha: 0.02)
        //        backgroundColor = .white
        
        addSubview(stackView)
        setupStackView()
    }
    
    private func setupLayer() {
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor =  UIColor(displayP3Red: 0.44, green: 0.44, blue: 0.44, alpha: 0.05).cgColor
        layer.masksToBounds = false
    }
    
    private func setupStackView() {
        stackView.frame = contentView.bounds
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let spacer = UIView()
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(spacer)
        
        setupTitle()
        setupIconImageView()
    }
    
    private func setupTitle() {
        titleLabel.text = "Bus"
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Poppins-medium", size: 14)
    }
    
    private func setupIconImageView() {
        iconImageView.image = UIImage(systemName: "bus")
        iconImageView.tintColor = UIColor(named: "mainColor")
        iconImageView.contentMode = .scaleAspectFit
        
        let iconSize: CGFloat = 32
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
    }
    
}


