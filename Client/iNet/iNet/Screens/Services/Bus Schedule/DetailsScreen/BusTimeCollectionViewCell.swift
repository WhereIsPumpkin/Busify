//
//  BusTimeCollectionViewCell.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import UIKit

class BusTimeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let mainHorizontalStack = UIStackView()
    private let busNumberStack = UIStackView()
    private let busIcon = UIImageView(image: UIImage(systemName: "bus.fill"))
    private let busNumber = UILabel()
    private let infoVerticalStack = UIStackView()
    private let busWaitTime = UILabel()
    private let busRoute = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.backgroundColor = UIColor(red: 0.224, green: 0.243, blue: 0.275, alpha: 0.3).cgColor
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        addSubview(mainHorizontalStack)
        setupMainHorizontalStack()
    }
    
    private func setupMainHorizontalStack() {
        mainHorizontalStack.isLayoutMarginsRelativeArrangement = true
        mainHorizontalStack.axis = .horizontal
        mainHorizontalStack.distribution = .fill
        mainHorizontalStack.spacing = 16
        mainHorizontalStack.alignment = .center
        mainHorizontalStack.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        setupMainHorizontalStackConstraints()
        setupBusNumberStack()
        setupInfoVerticalStack()
        mainHorizontalStack.addArrangedSubview(busNumberStack)
        mainHorizontalStack.addArrangedSubview(infoVerticalStack)
    }
    
    private func setupMainHorizontalStackConstraints() {
        mainHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainHorizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setupBusNumberStack() {
        busNumberStack.axis = .horizontal
        busNumberStack.spacing = 4
        busNumberStack.alignment = .center
        busNumberStack.heightAnchor.constraint(equalToConstant: 48).isActive = true
        busNumberStack.isLayoutMarginsRelativeArrangement = true
        busNumberStack.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        busNumberStack.backgroundColor = UIColor(red: 0.224, green: 0.243, blue: 0.275, alpha: 1)
        busNumberStack.layer.cornerRadius = 12
        setupBusIcon()
        setupBusNumberLabel()
        busNumberStack.addArrangedSubview(busIcon)
        busNumberStack.addArrangedSubview(busNumber)
    }
    
    private func setupBusIcon() {
        busIcon.translatesAutoresizingMaskIntoConstraints = false
        busIcon.tintColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.93)
        busIcon.contentMode = .scaleAspectFit
        busIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        busIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupBusNumberLabel() {
        busNumber.text = "293"
        busNumber.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.93)
        busNumber.font = UIFont(name: "Poppins-Bold", size: 24)
    }
    
    private func setupInfoVerticalStack() {
        infoVerticalStack.axis = .vertical
        infoVerticalStack.spacing = 4
        setupBusWaitTime()
        setupBusRoute()
        infoVerticalStack.addArrangedSubview(busWaitTime)
        infoVerticalStack.addArrangedSubview(busRoute)
    }
    
    private func setupBusWaitTime() {
        busWaitTime.text = "15 Min"
        busWaitTime.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        busWaitTime.font = UIFont(name: "Poppins-Bold", size: 16)
    }
    
    private func setupBusRoute() {
        busRoute.text = "Didi Dighomi IV M.R"
        busRoute.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.6)
        busRoute.font = UIFont(name: "Poppins-semibold", size: 14)
    }
    
}
