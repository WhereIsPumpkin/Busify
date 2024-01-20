//
//  BusScheduleViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import Lottie

class BusScheduleViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private var originalTopConstraint: NSLayoutConstraint!
    private let spacer = UIView()
    private let mainVerticalStack = UIStackView()
    private let busAnimationView = LottieAnimationView(name: "busAnimation")
    private var busAnimationHeight: NSLayoutConstraint!
    private let busSearchTextField = CustomStyledTextField(placeholder: "e.g Baratashvili... or 4230", isSecure: false)
    private let searchButton = CustomStyledButton(buttonText: "Search", buttonColor: UIColor(named: "mainColor")!, textColor: .white)
    private var viewModel = ServicesViewModel()
    private var tableView: UITableView?
    private let textFieldWrapper = UIStackView()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        configureViewController()
        setupMainVerticalStack()
        setupBusAnimationView()
        setupTitleLabel()
    }
    
    private func configureViewController() {
        title = "Bus Schedule"
        view.backgroundColor = .white
        view.addSubview(mainVerticalStack)
    }
    
    private func setupMainVerticalStack() {
        mainStackConfiguration()
        setupBusSearchTextField()
        setupTextFieldWrap()
        setupMainStackViewConstraints()
        setupTableView()
        setupMainStackSubViews()
        setupCustomSpacings()
        createDismissKeyboardGesture()
    }
    
    private func mainStackConfiguration() {
        mainVerticalStack.axis = .vertical
        mainVerticalStack.alignment = .fill
        mainVerticalStack.distribution = .fill
        mainVerticalStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupMainStackSubViews() {
        mainVerticalStack.addArrangedSubview(busAnimationView)
        mainVerticalStack.addArrangedSubview(titleLabel)
        mainVerticalStack.addArrangedSubview(textFieldWrapper)
        mainVerticalStack.addArrangedSubview(spacer)
    }
    
    private func setupCustomSpacings() {
        mainVerticalStack.setCustomSpacing(40, after: busAnimationView)
        mainVerticalStack.setCustomSpacing(40, after: titleLabel)
        mainVerticalStack.setCustomSpacing(40, after: busSearchTextField)
    }
    
    private func setupMainStackViewConstraints() {
        originalTopConstraint = mainVerticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        
        NSLayoutConstraint.activate([
            originalTopConstraint,
            mainVerticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVerticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainVerticalStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBusAnimationView() {
        busAnimationView.translatesAutoresizingMaskIntoConstraints = false
        busAnimationView.contentMode = .scaleAspectFill
        busAnimationView.loopMode = .loop
        busAnimationView.animationSpeed = 1.0
        busAnimationView.play()
        busAnimationHeight = busAnimationView.heightAnchor.constraint(equalToConstant: 200)
        busAnimationHeight.isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Choose Stop ID or Enter Address"
        titleLabel.font = UIFont(name: "Poppins-Medium", size: 16)
        titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        titleLabel.textAlignment = .center
    }
    
    private func setupTextFieldWrap() {
        textFieldWrapper.addArrangedSubview(busSearchTextField)
        textFieldWrapper.axis = .horizontal
        textFieldWrapper.isLayoutMarginsRelativeArrangement = true
        textFieldWrapper.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func setupBusSearchTextField() {
        busSearchTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        busSearchTextField.delegate = self
        busSearchTextField.onClearAction = {
            UIView.animate(withDuration: 0.3) {
                self.configureViewForTextFieldUnfocus()
            }
        }
    }
    
    private func setupTableView() {
        tableView = UITableView()
        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func createDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    let testData = ["Bus 1", "Bus 2", "Bus 3", "Bus 3","Bus 3","Bus 3","Bus 3","Bus 3",]
    
}

// MARK: - Extensions
extension BusScheduleViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == busSearchTextField {
            animateTextFieldFocused(true)
            Task {
                await viewModel.fetchBusStops { [weak self] error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print(error)  // TODO: - Error Handle
                        } else {
                            self?.tableView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == busSearchTextField {
            animateTextFieldFocused(false)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == busSearchTextField {
            var currentText = textField.text ?? ""
            if let textRange = Range(range, in: currentText) {
                currentText = currentText.replacingCharacters(in: textRange, with: string)
            }
            viewModel.filterLocations(with: currentText)
            tableView?.reloadData()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
}

extension BusScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFilteredLocations
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.filteredLocationName(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBusStopName = viewModel.filteredLocationName(at: indexPath.row)
        let detailsVC = BusStopDetailsPage()
        detailsVC.busStopName = selectedBusStopName
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - Animation Controll
extension BusScheduleViewController {
    private func animateTextFieldFocused(_ focused: Bool) {
        UIView.animate(withDuration: 0.3) {
            if focused {
                self.configureViewForTextFieldFocus()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureViewForTextFieldFocus() {
        hideBusAnimation()
        adjustSpacingsForFocus()
        hideTitleLabel()
        addTableViewToStack()
    }
    
    private func configureViewForTextFieldUnfocus() {
        unhideBusAnimation()
        resetSpacings()
        showTitleLabel()
        removeTableViewFromStack()
    }
    
    private func hideBusAnimation() {
        busAnimationView.alpha = 0
        busAnimationView.isHidden = true
    }
    
    private func unhideBusAnimation() {
        busAnimationView.isHidden = false
        busAnimationView.alpha = 1
    }
    
    private func adjustSpacingsForFocus() {
        mainVerticalStack.setCustomSpacing(16, after: self.titleLabel)
    }
    
    private func resetSpacings() {
        mainVerticalStack.setCustomSpacing(40, after: self.titleLabel)
    }
    
    private func hideTitleLabel() {
        titleLabel.alpha = 0
        titleLabel.isHidden = true
    }
    
    private func showTitleLabel() {
        titleLabel.isHidden = false
        titleLabel.alpha = 1
    }
    
    private func addTableViewToStack() {
        tableView!.alpha = 1
        mainVerticalStack.removeArrangedSubview(self.spacer)
        mainVerticalStack.addArrangedSubview(self.tableView!)
    }
    
    private func removeTableViewFromStack() {
        tableView!.alpha = 0
        mainVerticalStack.removeArrangedSubview(tableView!)
        mainVerticalStack.addArrangedSubview(spacer)
    }
}
