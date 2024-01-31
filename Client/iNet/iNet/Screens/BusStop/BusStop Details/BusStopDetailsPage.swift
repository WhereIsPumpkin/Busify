//
//  BusStopDetailsPage.swift
//  iNet
//
//  Created by Saba Gogrichiani on 20.01.24.
//

import UIKit

class BusStopDetailsPage: UIViewController {
    // MARK: - Properties
    var mainStackView = UIStackView()
    var heroImage = UIImageView(image: UIImage(resource: .busStop))
    var titleWrapper = UIStackView()
    var titleLabel = UILabel()
    var busWaitIcon = UIImageView(image: UIImage(resource: .busWaitIcon))
    var bookmarkIcon = UIImageView(image: UIImage(systemName: "bookmark"))
    var collectionView: UICollectionView!
    var arrivalTimes: ArrivalTimesResponse?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupUI()
    }
    
    init(arrivalTimes: ArrivalTimesResponse?) {
        self.arrivalTimes = arrivalTimes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func SetupUI() {
        SetupView()
    }
    
    private func SetupView() {
        setupViewAppearance()
        addViewSubviews()
        setupViewSubViews()
    }
    
    
    private func setupViewAppearance() {
        view.backgroundColor = UIColor(resource: .background)
    }
    
    private func addViewSubviews() {
        view.addSubview(heroImage)
        view.addSubview(mainStackView)
    }
    
    private func setupViewSubViews() {
        setupHeroImage()
        setupMainStackView()
    }
    
    private func setupHeroImage() {
        heroImage.contentMode = .scaleToFill
        setupHeroImageConstraints()
    }
    
    private func setupHeroImageConstraints() {
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heroImage.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupMainStackView() {
        setupMainStackViewAppearance()
        setupMainStackViewConstraints()
        setupMainStackViewArrangedSubviews()
        addMainStackViewArrangedSubviews()
    }
    
    private func setupMainStackViewAppearance() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    private func addMainStackViewArrangedSubviews() {
        mainStackView.addArrangedSubview(titleWrapper)
        mainStackView.addArrangedSubview(collectionView)
    }
    
    private func setupMainStackViewArrangedSubviews() {
        setupTitleWrapper()
        setupCollectionView()
    }
    
    private func setupMainStackViewConstraints() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: heroImage.bottomAnchor, constant: -34),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupTitleWrapper() {
        configureTitleWrapperLayout()
        addComponentsToTitleWrapper()
    }
    
    private func configureTitleWrapperLayout() {
        titleWrapper.axis = .horizontal
        titleWrapper.alignment = .top
        titleWrapper.spacing = 12
    }
    
    private func addComponentsToTitleWrapper() {
        setupBusWaitIcon()
        setupTitleLabel()
        addSpacerToTitleWrapper()
        setupBookmarkIcon()
    }
    
    private func setupBusWaitIcon() {
        titleWrapper.addArrangedSubview(busWaitIcon)
        setupBusWaitIconConstraints()
    }
    
    private func setupBusWaitIconConstraints() {
        busWaitIcon.translatesAutoresizingMaskIntoConstraints = false
        busWaitIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        busWaitIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Arrival Times:"
        titleLabel.textColor = UIColor(.accent)
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 20)
        titleWrapper.addArrangedSubview(titleLabel)
    }
    
    private func addSpacerToTitleWrapper() {
        titleWrapper.addArrangedSubview(UIView())
    }
    
    private func setupBookmarkIcon() {
        titleWrapper.addArrangedSubview(bookmarkIcon)
        setupBookmarkConstraints()
        setupBookmarkIconTapGesture()
    }
    
    private func setupBookmarkConstraints() {
        bookmarkIcon.translatesAutoresizingMaskIntoConstraints = false
        bookmarkIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        bookmarkIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupBookmarkIconTapGesture() {
        bookmarkIcon.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkIconTapped))
        bookmarkIcon.addGestureRecognizer(tapGesture)
    }
    
    @objc private func bookmarkIconTapped() {
        print("clicked")
    }
    
    private func initializeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func configureCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
    }
    
    private func setupCollectionViewDataSourceAndDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func registerCollectionViewCells() {
        collectionView.register(BusTimeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: initializeCollectionViewLayout())
        configureCollectionView()
        setupCollectionViewDataSourceAndDelegate()
        registerCollectionViewCells()
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension BusStopDetailsPage: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let arrivalTimes = arrivalTimes {
            return arrivalTimes.arrivalTime.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BusTimeCollectionViewCell
        if let arrivalTimes = arrivalTimes {
            let arrivalTime = arrivalTimes.arrivalTime[indexPath.row]
            cell.configure(with: arrivalTime)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let arrivalTimes = arrivalTimes {
            let modalViewController = ReminderViewController(busNumber: arrivalTimes.arrivalTime[indexPath.row])
            modalViewController.modalPresentationStyle = .pageSheet
            
            if let sheet = modalViewController.sheetPresentationController {
                let customHeight = self.view.frame.height * 0.65
                print(self.view.frame.height)
                sheet.detents = [.custom { context in customHeight }]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 20
            }
            
            present(modalViewController, animated: true, completion: nil)
        }
        
    }
}

extension BusStopDetailsPage: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 80
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}


@available(iOS 17, *)
#Preview {
    BusStopDetailsPage(arrivalTimes: ArrivalTimesResponse(arrivalTime: mockArrivalTimes.arrivalTime))
}
