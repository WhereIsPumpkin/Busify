//
//  ReminderViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 23.01.24.
//

import UIKit

final class ReminderViewController: UIViewController {
    // MARK: - Properties
    private let mainStack = UIStackView()
    private let configurationStack = UIStackView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let headerStack = UIStackView()
    private let busImage = UIImageView(image: UIImage(resource: .bus))
    private let allDayStack = UIStackView()
    private let allDayIconLabelWrapper = UIStackView()
    private let allDayIcon = UIImageView(image: UIImage(systemName: "clock.arrow.2.circlepath"))
    private let allDayLabel = UILabel()
    private let allDaySwitch = UISwitch()
    private let setReminderButton = UIButton()
    var busInfo: ArrivalTime = ArrivalTime(routeNumber: "000", destinationStopName: "NAN", arrivalTime: 0)
    let nearbyReminderStack = IconLabelStackView(icon: "deskclock", title: "setNearbyReminder", datePickerStyle: .countDownTimer)
    let timeReminderStack = IconLabelStackView(icon: "cursorarrow.click.badge.clock", title: "setTimeReminder", datePickerStyle: .time)
    private var nearbyReminderTime: String?
    private var timeReminderTime: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupReminderCallbacks()
    }
    
    init(busNumber: ArrivalTime) {
        super.init(nibName: nil, bundle: nil)
        self.busInfo = busNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup Methods
    private func setupUI() {
        setupView()
        setupMainStack()
    }
    
    private func setupReminderCallbacks() {
        nearbyReminderStack.onDateSelected = { [weak self] selectedTime in
            self?.timeReminderStack.resetView()
            self?.nearbyReminderTime = selectedTime
            self?.timeReminderTime = nil
            
            let newText = selectedTime.isEmpty ? "Set Nearby Reminder" : "\(selectedTime)"
            self?.nearbyReminderStack.updateTitleLabel(with: newText)
            
            self?.timeReminderStack.updateTitleLabel(with: "setTimeReminder")
        }
        
        timeReminderStack.onDateSelected = { [weak self] selectedTime in
            self?.nearbyReminderStack.resetView()
            self?.timeReminderTime = selectedTime
            self?.nearbyReminderTime = nil
            
            let newText = selectedTime.isEmpty ? "Set Time Reminder" : "\(selectedTime)"
            self?.timeReminderStack.updateTitleLabel(with: newText)
            
            self?.nearbyReminderStack.updateTitleLabel(with: "setNearbyReminder")
        }
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
        titleLabel.text = NSLocalizedString("setReminderTitle", comment: "Title for set a reminder screen")
        titleLabel.textColor = UIColor(resource: .accent)
        titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 20)
    }
    
    private func setupdescriptionLabel() {
        descriptionLabel.text = NSLocalizedString("setReminderDescription", comment: "Description for set a reminder screen")
        descriptionLabel.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 0.69)
        descriptionLabel.font = UIFont(name: "Poppins-medium", size: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
    }
    
    private func setupBusImage() {
        let textPosition = CGPoint(x: 330, y: 144)
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
        funcSetupAllDayStack()
        setupReminderButton()
    }
    
    private func setupConfigurationStackLayout() {
        configurationStack.axis = .vertical
        configurationStack.spacing = 16
        configurationStack.distribution = .fill
        configurationStack.setCustomSpacing(30, after: timeReminderStack)
        configurationStack.setCustomSpacing(30, after: allDayStack)
    }
    
    private func addConfigurationStackSubviews() {
        configurationStack.addArrangedSubview(nearbyReminderStack)
        configurationStack.addArrangedSubview(timeReminderStack)
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
        allDayLabel.text = NSLocalizedString("allDay", comment: "Label for all day switch")
        allDayLabel.textColor = UIColor(resource: .accent)
        allDayLabel.font = UIFont(name: "Poppins-semibold", size: 16)
    }
    
    private func setupReminderButton() {
        setReminderButton.backgroundColor = UIColor(resource: .alternate)
        setReminderButton.layer.cornerRadius = 12
        setReminderButton.setTitle(NSLocalizedString("setReminder", comment: "Button title for setting a reminder"), for: .normal)
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
        if let nearbyTime = nearbyReminderTime {
            let reminderTimeInMinutes = busInfo.arrivalTime - nearbyTime.toMinutes()
            
            if nearbyTime.toMinutes() >= busInfo.arrivalTime {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nearby time is greater than or equal to bus arrival time."])
                self.showErrorAlert(error)
                return
            }
            
            let (hour, minute) = Date().adding(minutes: reminderTimeInMinutes)
            
            let localizedBody = NSLocalizedString("busArrivalBody-string", comment: "Bus arrival notification body")
            guard let routeNumberInt = Int(busInfo.routeNumber) else { return }
            let formattedBody = String(format: localizedBody, routeNumberInt, nearbyTime.toMinutes())
            
            NotificationManager.shared.dispatchNotification(
                identifier: "nearbyReminder",
                title: "Reminder‼",
                body: formattedBody,
                hour: hour,
                minute: minute,
                isDaily: false
            )
            dismiss(animated: true)
        }
        else if let timeReminder = timeReminderTime {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            if let reminderDate = formatter.date(from: timeReminder) {
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: reminderDate)
                let minute = calendar.component(.minute, from: reminderDate)
                
                NotificationManager.shared.dispatchNotification(
                    identifier: "timeReminder",
                    title: "Time to Go!",
                    body: "It's time for your bus, #\(busInfo.routeNumber). Departure in just a few!",
                    hour: hour,
                    minute: minute,
                    isDaily: allDaySwitch.isOn
                )
                dismiss(animated: true)
            }
        } else {
            let alert = UIAlertController(title: "No Reminder Set", message: "Please select a reminder time.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    ReminderViewController(busNumber: ArrivalTime(routeNumber: "293", destinationStopName: "Test", arrivalTime: 123))
}

