//
//  BusStopDetailsPage.swift
//  iNet
//
//  Created by Saba Gogrichiani on 20.01.24.
//

import UIKit

class BusStopDetailsPage: UIViewController {
    // MARK: - Properties
    var busStopName: String?
    var mainStackView = UIStackView()
    var heroImage = UIImageView(image: UIImage(resource: .busStop))
    var titleWrapper = UIStackView()
    var titleLabel = UILabel()
    var busWaitIcon = UIImageView(image: UIImage(resource: .busWaitIcon))
    var collectionView: UICollectionView!
    
    struct BusTime {
        var time: String
    }
    
    // Sample data array
    var busTimes: [BusTime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTestData()
        SetupUI()
    }
    
    private func generateTestData() {
        // Generate random test data
        let sampleTimes = ["8:30 AM", "9:00 AM", "9:30 AM", "10:00 AM", "10:30 AM"]
        for _ in 1...10 {
            let randomIndex = Int(arc4random_uniform(UInt32(sampleTimes.count)))
            let busTime = BusTime(time: sampleTimes[randomIndex])
            busTimes.append(busTime)
        }
    }
    
    private func SetupUI() {
        SetupView()
    }
    
    private func SetupView() {
        setupViewAppearance()
        addViewSubviews()
        setupViewSubViews()
    }
    
    private func setupViewAppearance() {
        view.backgroundColor = UIColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1)
        title = busStopName
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
        titleWrapper.alignment = .center
        titleWrapper.spacing = 12
    }
    
    private func addComponentsToTitleWrapper() {
        setupBusWaitIcon()
        setupTitleLabel()
        addSpacerToTitleWrapper()
    }
    
    private func setupBusWaitIcon() {
        titleWrapper.addArrangedSubview(busWaitIcon)
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Bus Schedule:"
        titleLabel.textColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
        titleLabel.font = UIFont(name: "Poppins-Bold", size: 20)
        titleWrapper.addArrangedSubview(titleLabel)
    }
    
    private func addSpacerToTitleWrapper() {
        titleWrapper.addArrangedSubview(UIView())
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BusTimeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        configureCollectionViewAppearance()
        setupCollectionViewConstraints()
    }
    
    private func configureCollectionViewAppearance() {
        collectionView.backgroundColor = .clear
        // Additional configuration...
    }
    
    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension BusStopDetailsPage: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return busTimes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BusTimeCollectionViewCell
        let busTime = busTimes[indexPath.row]
   
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 80
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 16 // Spacing between rows
       }
}







