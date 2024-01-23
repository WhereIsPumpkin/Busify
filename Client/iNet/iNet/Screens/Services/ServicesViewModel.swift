//
//  ServicesViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 19.01.24.
//

import Foundation
import NetSwift

class ServicesViewModel {
    struct ServiceItem {
        let type: ServiceType
    }
    
    let serviceItems: [ServiceItem] = ServiceType.allCases.map { ServiceItem(type: $0) }
}


