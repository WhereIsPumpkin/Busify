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
        setupContentLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with arrivalTime: ArrivalTime) {
        busWaitTime.text = "\(arrivalTime.arrivalTime) Min"
        busNumber.text = arrivalTime.routeNumber
        busRoute.text = arrivalTime.destinationStopName
    }
    
    // MARK: - Private Methods
    private func setupContentLayout() {
        setupContent()
    }
    
    private func setupContent() {
        setupContentLayer()
        addSubview(mainHorizontalStack)
        setupMainHorizontalStack()
    }
    
    private func setupContentLayer() {
        layer.backgroundColor = UIColor(.base.opacity(0.3)).cgColor
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor(.accent.opacity(0.2)).cgColor
    }
    
    private func setupMainHorizontalStack() {
        setupMainHorizontalStackConstraints()
        setupMainHorizontalStackLayout()
        setupMainHorizontalStackArrangedSubviews()
        addMainHorizontalStackArrangedSubviews()
    }
    
    private func setupMainHorizontalStackLayout() {
        mainHorizontalStack.axis = .horizontal
        mainHorizontalStack.distribution = .fill
        mainHorizontalStack.spacing = 16
        mainHorizontalStack.alignment = .center
    }
    
    private func setupMainHorizontalStackArrangedSubviews() {
        setupBusNumberStack()
        setupInfoVerticalStack()
    }
    
    private func addMainHorizontalStackArrangedSubviews() {
        mainHorizontalStack.addArrangedSubview(busNumberStack)
        mainHorizontalStack.addArrangedSubview(infoVerticalStack)
    }
    
    private func setupMainHorizontalStackConstraints() {
        mainHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainHorizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainHorizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainHorizontalStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setupBusNumberStack() {
        setupBusNumberStackLayout()
        setupBusNumberStackLayoutMargins()
        setupBusNumberStackAppearance()
        setupBusIcon()
        setupBusNumberLabel()
        busNumberStack.addArrangedSubview(busIcon)
        busNumberStack.addArrangedSubview(busNumber)
    }
    
    private func setupBusNumberStackLayout() {
        busNumberStack.axis = .horizontal
        busNumberStack.spacing = 4
        busNumberStack.alignment = .center
        busNumberStack.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func setupBusNumberStackLayoutMargins() {
        busNumberStack.isLayoutMarginsRelativeArrangement = true
        busNumberStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    private func setupBusNumberStackAppearance() {
        busNumberStack.backgroundColor = UIColor(red: 0.224, green: 0.243, blue: 0.275, alpha: 1)
        busNumberStack.layer.cornerRadius = 12
    }
    
    private func setupBusIcon() {
        setupBusIconConstraints()
        setupBusIconAppearance()
    }
    
    private func setupBusIconConstraints() {
        busIcon.translatesAutoresizingMaskIntoConstraints = false
        busIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        busIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupBusIconAppearance() {
        busIcon.tintColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.93)
        busIcon.contentMode = .scaleAspectFit
    }
    
    private func setupBusNumberLabel() {
        busNumber.text = "293"
        busNumber.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.93)
        busNumber.font = UIFont(name: "Poppins-Bold", size: 22)
    }
    
    private func setupInfoVerticalStack() {
        setupInfoVerticalStackLayout()
        setupBusWaitTime()
        setupBusRoute()
        addInfoVerticalStackArrangedSubviews()
    }
    
    private func setupInfoVerticalStackLayout() {
        infoVerticalStack.axis = .vertical
        infoVerticalStack.spacing = 4
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
        busRoute.numberOfLines = 1
        busRoute.minimumScaleFactor = 0.7
        busRoute.adjustsFontSizeToFitWidth = true
        busRoute.lineBreakMode = .byTruncatingTail
        busRoute.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busRoute.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }

    
    private func addInfoVerticalStackArrangedSubviews() {
        infoVerticalStack.addArrangedSubview(busWaitTime)
        infoVerticalStack.addArrangedSubview(busRoute)
    }
}
