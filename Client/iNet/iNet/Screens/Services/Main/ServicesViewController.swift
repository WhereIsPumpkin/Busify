//
//  ServicesViewController.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import UIKit
import SwiftUI

class ServicesViewController: UIViewController {
    private var viewModel = ServicesViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let padding: CGFloat = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        let itemWidth = (view.frame.width - padding * 2 - layout.minimumInteritemSpacing * 2)
        let itemHeight = itemWidth / 40 * 9
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.register(ServicesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.addSubview(collectionView)
        navigationItem.title = "Services"
        
    }
}

extension ServicesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.serviceItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ServicesCollectionViewCell
        let item = viewModel.serviceItems[indexPath.row]
        cell.configure(with: item.type)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let serviceType = viewModel.serviceItems[indexPath.row].type
        
        switch serviceType {
        case .busSchedule:
            let busScheduleViewController = BusScheduleViewController()
            busScheduleViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(busScheduleViewController, animated: true)
        case .personalizedSuggestions:
            let chatBotViewController = UIHostingController(rootView: ChatBotView())
            self.navigationItem.title = ""
            navigationController?.pushViewController(chatBotViewController, animated: true)
        case .cinemaTickets:
            print("Cinema Tickets tapped")
        }
    }

    
}

