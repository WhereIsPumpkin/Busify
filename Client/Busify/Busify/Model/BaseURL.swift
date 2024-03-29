//
//  BaseURL.swift
//  iNet
//
//  Created by Saba Gogrichiani on 04.02.24.
//

import Foundation

enum BaseURL: String {
    case remote = "https://dull-ruby-python.cyclic.app"
    case local = "http://localhost:3000"
    
    static var production: BaseURL {
        return .local
    }
    
    var url: URL {
        guard let url = URL(string: self.rawValue) else {
            fatalError("Invalid base URL: \(self.rawValue)")
        }
        return url
    }
}
