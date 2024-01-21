//
//  CustomStyleTextField.swift
//  iNet
//
//  Created by Saba Gogrichiani on 20.01.24.
//

import UIKit

class CustomStyledTextField: UITextField {
    
    var isSecure: Bool {
        didSet {
            configureSecurityEntry()
        }
    }
    
    var onClearAction: (() -> Void)?
    
    init(placeholder: String, isSecure: Bool) {
        self.isSecure = isSecure
        super.init(frame: .zero)
        commonInit(placeholder: placeholder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit(placeholder: String) {
        setupTextFieldAppearance(withPlaceholder: placeholder)
        setupLeftImageView()
        setupRightClearButton()
        addTextChangeObserver()
    }
    
    private func configureSecurityEntry() {
        self.isSecureTextEntry = isSecure
    }
    
    private func setupTextFieldAppearance(withPlaceholder placeholder: String) {
        configurePlaceholder(placeholder)
        setHeightConstraint()
        styleTextField()
    }
    
    private func configurePlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
    private func setHeightConstraint() {
        self.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    private func styleTextField() {
        self.borderStyle = .none
        self.backgroundColor = UIColor(red: 57/255, green: 62/255, blue: 70/255, alpha: 1)
        self.layer.cornerRadius = 8
        self.autocapitalizationType = .none
        self.returnKeyType = .done
        self.clearButtonMode = .whileEditing
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    private func setupLeftImageView() {
        let leftSideImageView = createImageView()
        let paddingView = createPaddingView(withView: leftSideImageView)
        configureLeftView(withPaddingView: paddingView)
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 12, y: 7, width: 16, height: 16))
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    
    private func createPaddingView(withView view: UIView) -> UIView {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        paddingView.addSubview(view)
        return paddingView
    }
    
    private func configureLeftView(withPaddingView paddingView: UIView) {
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    private func setupRightClearButton() {
        let rightSideButton = createClearButton()
        let rightPaddingView = createPaddingView(withView: rightSideButton)
        configureRightView(withPaddingView: rightPaddingView)
    }
    
    private func createClearButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 7.5, y: 7.5, width: 15, height: 15))
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        return button
    }
    
    private func configureRightView(withPaddingView paddingView: UIView) {
        self.rightView = paddingView
        self.rightViewMode = .never
    }
    
    private func addTextChangeObserver() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func clearTextField() {
        clearText()
        invokeClearAction()
        updateClearButtonVisibility()
    }
    
    func clearText() {
        self.text = ""
        self.resignFirstResponder()
    }
    
    private func invokeClearAction() {
        onClearAction?()
    }

    @objc private func textFieldDidChange() {
        updateClearButtonVisibility()
    }

    func updateClearButtonVisibility() {
        self.rightViewMode = self.text?.isEmpty == false ? .always : .never
    }
}



