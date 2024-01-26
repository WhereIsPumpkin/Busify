//
//  IconLabelStackView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 26.01.24.
//

import UIKit

class IconLabelStackView: UIView {
    // MARK: - Properties
    var mainStack = UIStackView()
    var pickerStack = UIStackView()
    var iconImageView: UIImageView
    let titleLabel = UILabel()
    private let datePicker = UIDatePicker()
    var onDateSelected: ((String) -> Void)?
    private var doneButton = UIButton()
    private var datePickerStyle: UIDatePicker.Mode
    var tapAction: (() -> Void)?
    
    init(icon: String, title: String, datePickerStyle: UIDatePicker.Mode) {
        iconImageView = UIImageView(image: UIImage(systemName: icon))
        titleLabel.text = title
        self.datePickerStyle = datePickerStyle
        super.init(frame: .zero)
        addSubview(mainStack)
        setupMainStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Methods
    private func setupMainStack() {
        setupMainStackAppearance()
        setupMainStackSubviews()
        addMainStackTapGesture()
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupMainStackAppearance() {
        configureMainStackProperties()
        setupMainStackLayer()
        setupMainStackMargins()
    }
    
    private func setupMainStackSubviews() {
        addMainStackSubviews()
        configureMainStackSubviewProperties()
    }
    
    private func configureMainStackProperties() {
        mainStack.backgroundColor = UIColor(red: 0.133, green: 0.157, blue: 0.192, alpha: 0.3)
        mainStack.axis = .horizontal
        mainStack.spacing = 16
    }
    
    private func setupMainStackLayer() {
        mainStack.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        mainStack.layer.borderWidth = 1
        mainStack.layer.cornerRadius = 12
    }
    
    private func setupMainStackMargins() {
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(horizontal: 12, vertical: 12)
    }
    
    private func addMainStackSubviews() {
        mainStack.addArrangedSubview(iconImageView)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(UIView())
    }
    
    private func configureMainStackSubviewProperties() {
        setupIcon()
        setupLabel()
    }
    
    private func setupIcon() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupLabel() {
        titleLabel.textColor = UIColor(resource: .accent)
        titleLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    private func addMainStackTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPicker))
        mainStack.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showPicker() {
        guard let parentView = self.superview else {
            print("IconLabelStackView must be added to a superview before showing the date picker.")
            return
        }
        
        if pickerStack.superview == nil {
            setupPickerStack()
            setupDoneButton()
            setupDatePicker()
            parentView.addSubview(pickerStack)
            setupStackConstraints(parentView)
        }
    }
    
    private func setupPickerStack() {
        setupDatePickerWrapStackLayout()
        setupDatePickerFrame()
    }
    
    private func setupDatePickerWrapStackLayout() {
        pickerStack.axis = .vertical
        pickerStack.alignment = .trailing
        pickerStack.layer.cornerRadius = 12
        pickerStack.spacing = 16
        pickerStack.backgroundColor = UIColor(resource: .background)
    }
    
    private func setupDatePickerFrame() {
        pickerStack.isLayoutMarginsRelativeArrangement = true
        pickerStack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = datePickerStyle
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        pickerStack.addArrangedSubview(datePicker)
    }
    
    private func setupStackConstraints(_ parentView: UIView) {
        pickerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerStack.heightAnchor.constraint(equalToConstant: 250),
            pickerStack.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            pickerStack.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            pickerStack.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            
            datePicker.widthAnchor.constraint(equalToConstant: parentView.bounds.width - 24)
        ])
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        switch datePickerStyle {
        case .date:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let dateString = dateFormatter.string(from: sender.date)
            onDateSelected?(dateString)
        case .countDownTimer:
            let hours = Int(sender.countDownDuration / 3600)
            let minutes = Int(sender.countDownDuration.truncatingRemainder(dividingBy: 3600) / 60)
            let timeString = "\(hours) hours \(minutes) min"
            onDateSelected?(timeString)
        default:
            break
        }
    }
    
    private func setupDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(dismissDatePicker), for: .allTouchEvents)
        pickerStack.addArrangedSubview(doneButton)
        setupDoneButtonFont()
        setupDoneButtonConstraints()
    }
    
    private func setupDoneButtonFont() {
        if let poppinsSemiBoldFont = UIFont(name: "Poppins-Semibold", size: 16) {
            doneButton.titleLabel?.font = poppinsSemiBoldFont
        } else {
            print("Poppins-Semibold font not found, using system font instead.")
        }
    }
    
    private func setupDoneButtonConstraints() {
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc private func dismissDatePicker() {
        pickerStack.removeFromSuperview()
    }
}

@available(iOS 17.0, *)
#Preview {
    ProfileViewController()
}
