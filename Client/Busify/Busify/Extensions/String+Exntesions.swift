//
//  String+Exntesions.swift
//  iNet
//
//  Created by Saba Gogrichiani on 27.01.24.
//

import Foundation

extension String {
    func toMinutes() -> Int {
        let components = self.components(separatedBy: " ")
        guard components.count >= 4 else { return 0 }
        let hours = Int(components[0]) ?? 0
        let minutes = Int(components[2]) ?? 0
        return hours * 60 + minutes
    }
    
    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        return self.count >= 6 && self.count <= 12
    }
    
}
