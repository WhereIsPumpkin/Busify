//
//  BusScheduleTableViewCell.swift
//  iNet
//
//  Created by Saba Gogrichiani on 21.01.24.
//

import UIKit

class BusScheduleTableViewCell: UITableViewCell {
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .top
        return stack
    }()
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private let busIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .busStopIcon)
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(resource: .accent)
        return imageView
    }()

    
    private let busStopAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 0.7)
        return label
    }()
    
    private let busStopIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Poppins-Medium", size: 16)
        label.textColor = UIColor(resource: .accent)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(resource: .base)
        addSubview(mainStack)
        
        mainStack.addArrangedSubview(busIconImageView)
        mainStack.addArrangedSubview(infoStack)
        
        infoStack.addArrangedSubview(busStopIdLabel)
        infoStack.addArrangedSubview(busStopAddressLabel)
        infoStack.addArrangedSubview(UIView())
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            busIconImageView.widthAnchor.constraint(equalToConstant: 40) // Adjust size as needed
        ])
    }
    
    func configure(with address: String, id: String) {
        busStopAddressLabel.text = address
        busStopIdLabel.text = "Stop ID: \(id)"
    }
}


