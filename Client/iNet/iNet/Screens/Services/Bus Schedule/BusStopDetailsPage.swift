//
//  BusStopDetailsPage.swift
//  iNet
//
//  Created by Saba Gogrichiani on 20.01.24.
//

import UIKit

class BusStopDetailsPage: UIViewController {
    var busStopName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = busStopName
    }
}

