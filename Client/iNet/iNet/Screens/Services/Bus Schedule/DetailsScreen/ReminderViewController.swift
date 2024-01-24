//
//  ReminderViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 23.01.24.
//

import UIKit

class ReminderViewController: UIViewController {
    
    private let mainStack = UIStackView()
    private let configurationStack = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let headerStack = UIStackView()
    private let hourglassIcon = UIImageView(image: UIImage(systemName: "hourglass"))
    private let quickAlertLabel = UILabel()
    private let busImage = UIImageView(image: UIImage(resource: .bus))
    private let quickAlertStackView = UIStackView()
    private let quickAlertMinuteField = UITextField()
    private let innerStackView = UIStackView()
    private let pickerView = UIPickerView()
    private let advancedLabelStack = UIStackView()
    private let advancedLabel = UILabel()
    private let clockSettingIcon = UIImageView(image: UIImage(resource: .clockSettingIcon))
    private let clock = UILabel()
    private let datePickerStack = UIStackView()
    private let calendarIcon = UIImageView(image: UIImage(systemName: "calendar.badge.plus"))
    private let datePickerLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let timePickerStack = UIStackView()
    private let clockIcon = UIImageView(image: UIImage(systemName: "clock"))
    private let timePickerLabel = UILabel()
    private let allDayStack = UIStackView()
    private let allDayIconLabelWrapper = UIStackView()
    private let allDayIcon = UIImageView(image: UIImage(systemName: "repeat"))
    private let allDayLabel = UILabel()
    private let allDaySwitch = UISwitch()
    private let setReminderButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func setupUI() {
        setupView()
        setupMainStack()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 56/255, green: 59/255, blue: 63/255, alpha: 1)
        view.addSubview(mainStack)
    }
    
    private func setupMainStack() {
        addMainStackArrangedSubviews()
        setupMainStackLayout()
        setupMainStackMargins()
        setupMainStackArrangedSubviews()
    }
    
    private func setupMainStackLayout() {
        mainStack.frame = view.bounds
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.spacing = 8
        mainStack.setCustomSpacing(32, after: descriptionLabel)
        mainStack.setCustomSpacing(48, after: busImage)
    }
    
    private func setupMainStackMargins() {
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
    }
    
    private func addMainStackArrangedSubviews() {
        mainStack.addArrangedSubview(headerStack)
        mainStack.addArrangedSubview(descriptionLabel)
        mainStack.addArrangedSubview(busImage)
        mainStack.addArrangedSubview(configurationStack)
        mainStack.addArrangedSubview(UIView())
    }
    
    private func setupMainStackArrangedSubviews() {
        setupTitleLabel()
        setupHeaderStack()
        setupdescriptionLabel()
        setupBusImage()
        setupConfigurationStack()
    }
    
    private func setupHeaderStack() {
        headerStack.axis = .horizontal
        headerStack.addArrangedSubview(titleLabel)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Set a Reminder"
        titleLabel.textColor = UIColor(resource: .accent)
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
    }
    
    private func setupdescriptionLabel() {
        descriptionLabel.text = "Manage your bus schedules for with personalized reminders."
        descriptionLabel.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.69)
        descriptionLabel.font = UIFont(name: "Poppins-medium", size: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
    }
    
    private func setupBusImage() {
        let text = "N293"
        let textPosition = CGPoint(x: 315, y: 140)
        let busImageOriginal = UIImage(resource: .bus)
        let busImageWithText = textToImage(drawText: text, inImage: busImageOriginal, atPoint: textPosition)
        busImage.contentMode = .scaleAspectFit
        busImage.image = busImageWithText
        setupBusSize()
    }
    
    private func setupBusSize() {
        busImage.translatesAutoresizingMaskIntoConstraints = false
        busImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        busImage.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    private func setupConfigurationStack() {
        addConfigurationStackSubviews()
        setupConfigurationStackLayout()
        setupConfigurationStackConstraints()
        setupQuickAlertStackView()
        setupAdvancedStack()
        setupDatePickerStack()
        setupTimePickerStack()
        funcSetupAllDayStack()
        setupReminderButton()
    }
    
    private func setupConfigurationStackLayout() {
        configurationStack.axis = .vertical
        configurationStack.spacing = 16
        configurationStack.distribution = .fill
        configurationStack.setCustomSpacing(30, after: timePickerStack)
        configurationStack.setCustomSpacing(30, after: allDayStack)
    }
    
    private func addConfigurationStackSubviews() {
        configurationStack.addArrangedSubview(quickAlertStackView)
        configurationStack.addArrangedSubview(advancedLabelStack)
        configurationStack.addArrangedSubview(datePickerStack)
        configurationStack.addArrangedSubview(timePickerStack)
        configurationStack.addArrangedSubview(allDayStack)
        configurationStack.addArrangedSubview(setReminderButton)
    }
    
    private func setupConfigurationStackConstraints() {
        configurationStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            configurationStack.leadingAnchor.constraint(equalTo: mainStack.layoutMarginsGuide.leadingAnchor),
            configurationStack.trailingAnchor.constraint(equalTo: mainStack.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func setupQuickAlertStackView() {
        configureQuickAlertStackView()
        addIconAndLabel()
        configureQuickAlertMinuteField()
        addArrangedSubviews()
    }
    
    private func configureQuickAlertStackView() {
        quickAlertStackView.axis = .horizontal
        quickAlertStackView.alignment = .center
        quickAlertStackView.distribution = .fill
        quickAlertStackView.spacing = 8
    }
    
    private func addIconAndLabel() {
        setupQuickAlertInnerStackView()
        setupHourGlassIcon()
        setupQuickAlertLabel()
    }
    
    private func setupQuickAlertInnerStackView() {
        innerStackView.axis = .horizontal
        innerStackView.spacing = 12
        innerStackView.addArrangedSubview(hourglassIcon)
        innerStackView.addArrangedSubview(quickAlertLabel)
    }
    
    private func setupHourGlassIcon() {
        hourglassIcon.contentMode = .scaleAspectFit
        hourglassIcon.translatesAutoresizingMaskIntoConstraints = false
        hourglassIcon.contentMode = .scaleAspectFit
        hourglassIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        hourglassIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupQuickAlertLabel() {
        quickAlertLabel.text = "Quick Alert"
        quickAlertLabel.textColor = UIColor(resource: .accent)
        quickAlertLabel.font = UIFont(name: "Poppins-Bold", size: 18)
    }
    
    private func configureQuickAlertMinuteField() {
        quickAlertMinuteField.placeholder = "Set Min"
        quickAlertMinuteField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        quickAlertMinuteField.inputView = pickerView
        quickAlertMinuteField.font = UIFont(name: "Poppins-Bold", size: 18)
    }
    
    private func addArrangedSubviews() {
        quickAlertStackView.addArrangedSubview(innerStackView)
        quickAlertStackView.addArrangedSubview(quickAlertMinuteField)
    }
    
    private func setupAdvancedStack() {
        advancedLabelStack.axis = .horizontal
        advancedLabelStack.spacing = 16
        advancedLabelStack.isLayoutMarginsRelativeArrangement = true
        advancedLabelStack.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        setupClockSettingIcon()
        setupAdvancedLabel()
        advancedLabelStack.addArrangedSubview(clockSettingIcon)
        advancedLabelStack.addArrangedSubview(advancedLabel)
    }
    
    private func setupClockSettingIcon() {
        clockSettingIcon.translatesAutoresizingMaskIntoConstraints = false
        clockSettingIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clockSettingIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupAdvancedLabel() {
        advancedLabel.text = "Advanced"
        advancedLabel.font = UIFont(name: "Poppins-Medium", size: 14)
        advancedLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
    }
    
    private func setupDatePickerStack() {
        datePickerStack.axis = .horizontal
        datePickerStack.layer.borderWidth = 1
        datePickerStack.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        datePickerStack.layer.cornerRadius = 12
        datePickerStack.isLayoutMarginsRelativeArrangement = true
        datePickerStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        datePickerStack.backgroundColor = UIColor(red: 0.133, green: 0.157, blue: 0.192, alpha: 0.3)
        datePickerStack.spacing = 16
        setupCalendarIcon()
        setupDatePickerLabel()
        datePickerStack.addArrangedSubview(calendarIcon)
        datePickerStack.addArrangedSubview(datePickerLabel)
        datePickerStack.addArrangedSubview(UIView())
    }
    
    private func setupCalendarIcon() {
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        calendarIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupDatePickerLabel() {
        datePickerLabel.text = "1st, August, 2023"
        datePickerLabel.textColor = UIColor(resource: .accent)
        datePickerLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    private func setupTimePickerStack() {
        timePickerStack.axis = .horizontal
        timePickerStack.axis = .horizontal
        timePickerStack.layer.borderWidth = 1
        timePickerStack.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        timePickerStack.layer.cornerRadius = 12
        timePickerStack.isLayoutMarginsRelativeArrangement = true
        timePickerStack.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        timePickerStack.backgroundColor = UIColor(red: 0.133, green: 0.157, blue: 0.192, alpha: 0.3)
        timePickerStack.spacing = 16
        setupClockIcon()
        setupTimePickerLabel()
        timePickerStack.addArrangedSubview(clockIcon)
        timePickerStack.addArrangedSubview(timePickerLabel)
        timePickerStack.addArrangedSubview(UIView())
    }
    
    private func setupClockIcon() {
        clockIcon.translatesAutoresizingMaskIntoConstraints = false
        clockIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        clockIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupTimePickerLabel() {
        timePickerLabel.text = "08:00 AM"
        timePickerLabel.textColor = UIColor(resource: .accent)
        timePickerLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    private func funcSetupAllDayStack() {
        allDayStack.axis = .horizontal
        setupAllDayIconLabelWrapper()
        allDayStack.addArrangedSubview(allDayIconLabelWrapper)
        allDayStack.addArrangedSubview(allDaySwitch)
    }
    
    private func setupAllDayIconLabelWrapper() {
        allDayIconLabelWrapper.axis = .horizontal
        allDayIconLabelWrapper.spacing = 12
        setupAllDayLabel()
        setupAllDayIcon()
        allDayIconLabelWrapper.addArrangedSubview(allDayIcon)
        allDayIconLabelWrapper.addArrangedSubview(allDayLabel)
        allDayIconLabelWrapper.addArrangedSubview(UIView())
    }
    
    private func setupAllDayIcon() {
        allDayIcon.translatesAutoresizingMaskIntoConstraints = false
        allDayIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        allDayIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupAllDayLabel() {
        allDayLabel.text = "All day"
        allDayLabel.textColor = UIColor(resource: .accent)
        allDayLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    private func setupReminderButton() {
        setReminderButton.backgroundColor = UIColor(resource: .alternate)
        setReminderButton.layer.cornerRadius = 20
        setReminderButton.layer.borderWidth = 1
        setReminderButton.setTitle("Set Reminder", for: .normal)
        setReminderButton.layer.borderColor = UIColor(resource: .accent).cgColor
        setReminderButton.translatesAutoresizingMaskIntoConstraints = false
        setReminderButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    let minutes = [0,5,10,15,20,25,30,35,40,45,50,55,60]
}

extension ReminderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        minutes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(minutes[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quickAlertMinuteField.text = "\(minutes[row]) Min"
        quickAlertMinuteField.resignFirstResponder()
    }
    
    
}

@available(iOS 17.0, *)
#Preview {
    ReminderViewController()
}

