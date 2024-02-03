//
//  CardCheckAnimation.swift
//  iNet
//
//  Created by Saba Gogrichiani on 04.02.24.
//

import UIKit
import Lottie

class CardCheckAnimation: UIStackView {
    // MARK: - Properties
    private let busAnimationView = LottieAnimationView(name: "cardScan")
    private let titleLabel = UILabel()
    private var timer: Timer?
    private var dotCount = 0 // To track the number of dots
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        DispatchQueue.main.async {
            self.widthAnchor.constraint(equalToConstant: 400).isActive = true
        }

    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Common Initialization
    private func commonInit() {
        setupStackView()
        setupLabel()
        setupBusAnimationView()
        layoutBusAnimationView()
        startAnimatingTitleLabel()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            setResponsiveWidth()
        }
    }
    
    // MARK: - Set Responsive Width for Stack View
    private func setResponsiveWidth() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 32),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -32)
        ])
    }
    
    // MARK: - Setup Components
    private func setupStackView() {
        axis = .vertical
        alignment = .center
        distribution = .fill
        backgroundColor = .background
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(horizontal: 64, vertical: 32)
        layer.cornerRadius = 20
        setupLayer()
    }
    
    private func setupLayer() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    private func setupBusAnimationView() {
        busAnimationView.contentMode = .scaleAspectFit
        busAnimationView.loopMode = .loop
        busAnimationView.play()
        addArrangedSubview(busAnimationView)
        busAnimationView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLabel() {
        titleLabel.text = "Identifying your card"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Poppins-semibold", size: 16)
        titleLabel.textColor = .white
        addArrangedSubview(titleLabel)
    }
    
    private func layoutBusAnimationView() {
        DispatchQueue.main.async {
            NSLayoutConstraint.activate([
                self.busAnimationView.heightAnchor.constraint(equalToConstant: 144),
                self.busAnimationView.widthAnchor.constraint(equalToConstant: 164),
            ])
        }
    }

    
    // MARK: - Animated Title Label
    private func startAnimatingTitleLabel() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTitleLabel), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTitleLabel() {
        dotCount = (dotCount + 1) % 4
        let dots = String(repeating: ".", count: dotCount)
        titleLabel.text = "Identifying your card\(dots)"
    }
    
    deinit {
        timer?.invalidate()
    }
}

#Preview {
    CardCheckAnimation()
}
