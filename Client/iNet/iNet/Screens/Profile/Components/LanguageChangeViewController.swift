//
//  LanguageChangeViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 04.02.24.
//

import UIKit

protocol LanguageChangeViewControllerDelegate: AnyObject {
    func didSelectLanguage(language: Language)
}

enum Language: String {
    case georgian = "Georgian"
    case english = "English"
}

class LanguageChangeViewController: UIStackView {
    // MARK: - Properties
    private let languageLabel = UILabel()
    private let georgianLanguageView = UIView()
    private let englishLanguageView = UIView()
    private let georgianLabel = UILabel()
    private let englishLabel = UILabel()
    weak var delegate: LanguageChangeViewControllerDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLanguageChangeView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupLanguageChangeView()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        constrainToMaxWidth()
        
        updateLanguageSelection(selectedLanguageView: englishLanguageView)
    }
    
    // MARK: - Setup Methods
    private func setupLanguageChangeView() {
        applyStackViewStyle()
        configureLanguageLabel()
        setupLanguageViews()
        layoutLanguageOptions()
    }
    
    func constrainToMaxWidth() {
        guard let superview = self.superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func applyStackViewStyle() {
        backgroundColor = .base
        axis = .horizontal
        distribution = .fill
        alignment = .center
        spacing = 10
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(horizontal: 16, vertical: 12)
        setupLayer()
    }
    
    private func setupLayer() {
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = UIColor(.accent.opacity(0.2)).cgColor
    }
    
    private func configureLanguageLabel() {
        languageLabel.text = "Language"
        languageLabel.textColor = .white
        languageLabel.font = UIFont(name: "Poppins-semibold", size: 16)
        addArrangedSubview(languageLabel)
    }
    
    private func setupLanguageViews() {
        configureLanguageView(georgianLanguageView, withLabel: georgianLabel, text: "ქართული")
        configureLanguageView(englishLanguageView, withLabel: englishLabel, text: "English")
    }
    
    private func configureLanguageView(_ view: UIView, withLabel label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: "Poppins-medium", size: 10)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        view.layer.cornerRadius = 12
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLanguageTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 24),
            view.widthAnchor.constraint(equalToConstant: 72),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    @objc private func handleLanguageTap(_ sender: UITapGestureRecognizer) {
        let language: Language = (sender.view == georgianLanguageView) ? .georgian : .english
        
        delegate?.didSelectLanguage(language: language)
        
        updateLanguageSelection(selectedLanguageView: sender.view)
    }
    
    private func updateLanguageSelection(selectedLanguageView: UIView?) {
        let selectedColor = UIColor(.alternate)
        let unselectedColor = UIColor(red: 64/255, green: 97/255, blue: 99/255, alpha: 1)
        
        georgianLanguageView.backgroundColor = (selectedLanguageView == georgianLanguageView) ? selectedColor : unselectedColor
        englishLanguageView.backgroundColor = (selectedLanguageView == englishLanguageView) ? selectedColor : unselectedColor
        
        let selectedLabelColor = UIColor.white
        let unselectedLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        georgianLabel.textColor = (selectedLanguageView == georgianLanguageView) ? selectedLabelColor : unselectedLabelColor
        englishLabel.textColor = (selectedLanguageView == englishLanguageView) ? selectedLabelColor : unselectedLabelColor
    }
    
    private func layoutLanguageOptions() {
        let languageOptionsStackView = UIStackView(arrangedSubviews: [georgianLanguageView, englishLanguageView])
        configureLanguageOptionsStackView(languageOptionsStackView)
        addArrangedSubview(languageOptionsStackView)
    }
    
    private func configureLanguageOptionsStackView(_ stackView: UIStackView) {
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        
        georgianLanguageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        englishLanguageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

#Preview {
    LanguageChangeViewController()
}
