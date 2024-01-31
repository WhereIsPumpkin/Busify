//
//  BusScheduleViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import Lottie

class BusStopSearchViewController: UIViewController {
    // MARK: - Properties
    private let titleLabel = UILabel()
    private var originalTopConstraint: NSLayoutConstraint!
    private let spacer = UIView()
    private let mainVerticalStack = UIStackView()
    private let busAnimationView = LottieAnimationView(name: "busAnimation")
    private var busAnimationHeight: NSLayoutConstraint!
    private let busSearchTextField = CustomStyledTextField(placeholder: "e.g Baratashvili... or 4230", isSecure: false)
    private let searchButton = CustomStyledButton(buttonText: "Search", buttonColor: UIColor(resource: .background), textColor: .white)
    private var viewModel = BusStopSearchViewModel()
    private var tableView: UITableView?
    private let textFieldWrapper = UIStackView()
    let returnButton = UIButton(type: .system)
    
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
        title = "Bus Stop"
        view.backgroundColor = UIColor(.background)
        view.addSubview(mainVerticalStack)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
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
        titleLabel.text = "Enter Stop ID or Enter Address"
        titleLabel.font = UIFont(name: "Poppins-Medium", size: 16)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
    }
    
    private func setupTextFieldWrap() {
        textFieldWrapper.addArrangedSubview(busSearchTextField)
        setupReturnButton()
        textFieldWrapper.axis = .horizontal
        textFieldWrapper.spacing = 8
        textFieldWrapper.isLayoutMarginsRelativeArrangement = true
        textFieldWrapper.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    }
    
    private func setupReturnButton() {
        returnButton.setImage(UIImage(systemName: "arrow.down.right.and.arrow.up.left"), for: .normal)
        returnButton.tintColor = UIColor(resource: .accent)
        returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        returnButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        returnButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc private func returnButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.configureViewForTextFieldUnfocus()
            self.viewModel.filterLocations(with: "")
            self.tableView?.reloadData()
            self.busSearchTextField.clearText()
            self.busSearchTextField.updateClearButtonVisibility()
        }
    }
    
    private func setupBusSearchTextField() {
        busSearchTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        busSearchTextField.delegate = self
        busSearchTextField.onClearAction = {
            UIView.animate(withDuration: 0.3) {
                self.viewModel.filterLocations(with: "")
                self.tableView?.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView?.backgroundColor = UIColor(resource: .background)
        guard let tableView = tableView else { return }
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(BusStopSearchTableViewCell.self, forCellReuseIdentifier: "BusScheduleCell")
    }
    
    private func createDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Extensions
extension BusStopSearchViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == busSearchTextField {
            animateTextFieldFocused(true)
            tableView?.reloadData()
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

extension BusStopSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfFilteredLocations
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusScheduleCell", for: indexPath) as? BusStopSearchTableViewCell else {
            return UITableViewCell()
        }
        let locationName = viewModel.filteredLocation(at: indexPath.row)
        guard let code = locationName.code else {
            cell.configure(with: locationName.name, id: "0000")
            return cell
        }
        cell.configure(with: locationName.name, id: "\(code)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBusStop = viewModel.filteredLocation(at: indexPath.row)
        
        // TODO: - Removed try
        Task {
             await viewModel.fetchBusStopArrivalTimes(stopID: selectedBusStop.code ?? "1466") {
                DispatchQueue.main.async { [weak self] in
                    let detailsVC = BusStopDetailsPage(arrivalTimes: self?.viewModel.selectedBusStopArrivalTimes, stopId: selectedBusStop.code ?? "1466")
                    detailsVC.title = "Stop: #\(selectedBusStop.code ?? "0000")"
                    self?.navigationController?.pushViewController(detailsVC, animated: true)
                }
            }
        }
    }
}

// MARK: - Animation Controll
extension BusStopSearchViewController {
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
        showReturnButton()
        adjustSpacingsForFocus()
        hideTitleLabel()
        addTableViewToStack()
    }
    
    private func configureViewForTextFieldUnfocus() {
        unhideBusAnimation()
        hideReturnButton()
        resetSpacings()
        showTitleLabel()
        removeTableViewFromStack()
    }
    
    private func showReturnButton() {
        returnButton.alpha = 1
        textFieldWrapper.addArrangedSubview(returnButton)
    }
    
    private func hideReturnButton() {
        returnButton.alpha = 0
        textFieldWrapper.removeArrangedSubview(returnButton)
    }
    
    private func hideBusAnimation() {
        busAnimationView.alpha = 0
        busAnimationView.isHidden = true
    }
    
    private func unhideBusAnimation() {
        busAnimationView.alpha = 1
        busAnimationView.isHidden = false
    }
    
    private func adjustSpacingsForFocus() {
        // Sizing Adjust //TODO: - Look for sizes
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
