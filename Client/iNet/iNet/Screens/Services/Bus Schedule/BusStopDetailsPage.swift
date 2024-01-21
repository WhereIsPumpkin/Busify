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
        view.backgroundColor = UIColor(red: 34/255, green: 40/255, blue: 49/255, alpha: 1)
        title = busStopName
    }
}

