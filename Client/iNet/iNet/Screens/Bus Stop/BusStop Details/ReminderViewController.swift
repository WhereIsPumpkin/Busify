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
    private let busImage = UIImageView(image: UIImage(resource: .bus))
    private let datePickerStack = UIStackView()
    private let calendarIcon = UIImageView(image: UIImage(systemName: "timer"))
    private let datePickerLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let datePickerWrapStack = UIStackView()
    private let timePickerStack = UIStackView()
    private let clockIcon = UIImageView(image: UIImage(systemName: "calendar.badge.clock"))
    private let timePickerLabel = UILabel()
    private let allDayStack = UIStackView()
    private let allDayIconLabelWrapper = UIStackView()
    private let allDayIcon = UIImageView(image: UIImage(systemName: "clock.arrow.2.circlepath"))
    private let allDayLabel = UILabel()
    private let allDaySwitch = UISwitch()
    let timePickerDoneButton = UIButton(type: .system)
    private let setReminderButton = UIButton()
    private let timePickerWrapStack = UIStackView()
    private var selectedDate: Date?
    private var selectedTime: Date?
    private let timePicker = UIDatePicker()
    let doneButton = UIButton(type: .system)
    var currentReminder: Reminder?
    var busInfo: ArrivalTime = ArrivalTime(routeNumber: "000", destinationStopName: "NAN", arrivalTime: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(busNumber: ArrivalTime) {
        super.init(nibName: nil, bundle: nil)
        self.busInfo = busNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let textPosition = CGPoint(x: 315, y: 140)
        let busImageOriginal = UIImage(resource: .bus)
        let busImageWithText = textToImage(drawText: busInfo.routeNumber, inImage: busImageOriginal, atPoint: textPosition)
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
    
    private func setupDatePickerStack() {
        setupDatePickerLayout()
        setupDatePickerStackLayer()
        setupDatePickerStackMargins()
        setupCalendarIcon()
        setupDatePickerLabel()
        addDatePickerStackArrangedSubviews()
        addDatePickerStackTapGesture()
    }
    
    private func setupDatePickerLayout() {
        datePickerStack.axis = .horizontal
        datePickerStack.backgroundColor = UIColor(red: 0.133, green: 0.157, blue: 0.192, alpha: 0.3)
        datePickerStack.spacing = 16
    }
    
    private func setupDatePickerStackLayer() {
        datePickerStack.layer.borderWidth = 1
        datePickerStack.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        datePickerStack.layer.cornerRadius = 12
    }
    
    private func setupDatePickerStackMargins() {
        datePickerStack.isLayoutMarginsRelativeArrangement = true
        datePickerStack.layoutMargins = UIEdgeInsets(horizontal: 12, vertical: 12)
    }
    
    private func addDatePickerStackArrangedSubviews() {
        datePickerStack.addArrangedSubview(calendarIcon)
        datePickerStack.addArrangedSubview(datePickerLabel)
        datePickerStack.addArrangedSubview(UIView())
    }
    
    private func addDatePickerStackTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        datePickerStack.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showDatePicker() {
        if datePickerWrapStack.superview == nil {
            setupDatePickerWrapStack()
            setupDoneButton()
            setupDatePicker()
        }
    }
    
    private func setupDatePickerWrapStack() {
        setupDatePickerWrapStackLayout()
        setupDatePickerFrame()
        self.view.addSubview(datePickerWrapStack)
    }
    
    private func setupDatePickerWrapStackLayout() {
        datePickerWrapStack.axis = .vertical
        datePickerWrapStack.alignment = .trailing
        datePickerWrapStack.layer.cornerRadius = 12
        datePickerWrapStack.spacing = 16
        datePickerWrapStack.backgroundColor = UIColor(resource: .background)
    }
    
    private func setupDatePickerFrame() {
        datePickerWrapStack.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
        datePickerWrapStack.isLayoutMarginsRelativeArrangement = true
        datePickerWrapStack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: view.bounds.width - 24).isActive = true
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePickerWrapStack.addArrangedSubview(datePicker)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        datePickerLabel.text = dateFormatter.string(from: sender.date)
    }
    
    private func setupDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(dismissDatePicker), for: .allTouchEvents)
        datePickerWrapStack.addArrangedSubview(doneButton)
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
        datePickerWrapStack.removeFromSuperview()
    }
    
    private func setupCalendarIcon() {
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        calendarIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupDatePickerLabel() {
        datePickerLabel.text = "Set Nearby Reminder"
        datePickerLabel.textColor = UIColor(resource: .accent)
        datePickerLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    
    
    private func setupTimePickerStack() {
        setupTimePickerStackLayout()
        setupClockIcon()
        setupTimePickerLabel()
        addTimePickerStackArrangedSubviews()
        addTimePickerStackGestureRecognizer()
    }
    
    private func setupTimePickerStackLayout() {
        timePickerStack.axis = .horizontal
        timePickerStack.backgroundColor = UIColor(red: 0.133, green: 0.157, blue: 0.192, alpha: 0.3)
        timePickerStack.spacing = 16
        setupTimePickerStackMargins()
        setupTimePickerStackLayer()
    }
    
    private func setupTimePickerStackLayer() {
        timePickerStack.layer.borderWidth = 1
        timePickerStack.layer.borderColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1).cgColor
        timePickerStack.layer.cornerRadius = 12
    }
    
    private func setupTimePickerStackMargins() {
        timePickerStack.isLayoutMarginsRelativeArrangement = true
        timePickerStack.layoutMargins = UIEdgeInsets(horizontal: 12, vertical: 12)
    }
    
    private func addTimePickerStackArrangedSubviews() {
        timePickerStack.addArrangedSubview(clockIcon)
        timePickerStack.addArrangedSubview(timePickerLabel)
        timePickerStack.addArrangedSubview(UIView())
    }
    
    private func addTimePickerStackGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTimePicker))
        timePickerStack.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showTimePicker() {
        if timePickerWrapStack.superview == nil {
            setupTimePickerWrapStack()
            setupTimeDoneButton()
            setupTimePicker()
        }
    }
    
    private func setupTimePickerWrapStack() {
        setupTimePickerWrapStackLayout()
        setupTimePickerWrapFrame()
        view.addSubview(timePickerWrapStack)
    }
    
    private func setupTimePickerWrapFrame() {
        timePickerWrapStack.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
        timePickerWrapStack.isLayoutMarginsRelativeArrangement = true
        timePickerWrapStack.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    }
    
    private func setupTimePickerWrapStackLayout() {
        timePickerWrapStack.axis = .vertical
        timePickerWrapStack.alignment = .trailing
        timePickerWrapStack.layer.cornerRadius = 12
        timePickerWrapStack.spacing = 16
        timePickerWrapStack.backgroundColor = UIColor(resource: .background)
    }
    
    private func setupTimePicker() {
        timePicker.datePickerMode = .countDownTimer
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.widthAnchor.constraint(equalToConstant: view.bounds.width - 24).isActive = true
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        timePickerWrapStack.addArrangedSubview(timePicker)
    }
    
    private func setupTimeDoneButton() {
        timePickerDoneButton.setTitle("Done", for: .normal)
        timePickerDoneButton.addTarget(self, action: #selector(dismissTimePicker), for: .allTouchEvents)
        timePickerWrapStack.addArrangedSubview(timePickerDoneButton)
        setupTimePickerDoneButtonFont()
        setupTimePickerDoneButtonConstraints()
    }
    
    private func setupTimePickerDoneButtonFont() {
        if let poppinsSemiBoldFont = UIFont(name: "Poppins-Semibold", size: 16) {
            timePickerDoneButton.titleLabel?.font = poppinsSemiBoldFont
        } else {
            print("Poppins-Semibold font not found, using system font instead.")
        }
    }
    
    private func setupTimePickerDoneButtonConstraints() {
        timePickerDoneButton.translatesAutoresizingMaskIntoConstraints = false
        timePickerDoneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timePickerDoneButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc private func dismissTimePicker() {
        timePickerWrapStack.removeFromSuperview()
    }
    
    @objc private func timeChanged(_ sender: UIDatePicker) {
        selectedTime = sender.date
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timePickerLabel.text = timeFormatter.string(from: sender.date)
    }
    
    private func setupClockIcon() {
        clockIcon.translatesAutoresizingMaskIntoConstraints = false
        clockIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        clockIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupTimePickerLabel() {
        timePickerLabel.text = "Set Time Reminder"
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
        allDayIcon.contentMode = .scaleAspectFill
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
        setReminderButton.layer.cornerRadius = 12
        setReminderButton.setTitle("Set Reminder", for: .normal)
        setReminderButton.translatesAutoresizingMaskIntoConstraints = false
        setReminderButton.addTarget(self, action: #selector(setReminderButtonTapped), for: .touchUpInside)
        setReminderButton.heightAnchor.constraint(equalToConstant: 52).isActive = true
        if let poppinsSemiBoldFont = UIFont(name: "Poppins-Semibold", size: 16) {
            setReminderButton.titleLabel?.font = poppinsSemiBoldFont
        } else {
            print("Poppins-Semibold font not found, using system font instead.")
        }
    }
    
    @objc private func setReminderButtonTapped(_ sender: UIButton) {
        print("123")
    }
    
}


@available(iOS 17.0, *)
#Preview {
    ReminderViewController(busNumber: ArrivalTime(routeNumber: "293", destinationStopName: "Test", arrivalTime: 123))
}

