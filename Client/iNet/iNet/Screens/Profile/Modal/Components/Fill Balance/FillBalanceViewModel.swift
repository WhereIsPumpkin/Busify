//
//  FillBalanceViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 03.02.24.
//

import Foundation

final class FillBalanceViewModel: ObservableObject {
    @Published var amount: String = ""
    
    func updateAmount(oldValue: String, newValue: String) {
        if !newValue.contains("$") {
            print(newValue)
            if newValue.count == 1, !oldValue.contains("$") {
                print(newValue)
                amount = newValue + "$"
            } else if newValue.count != 0 {
                let x = newValue.dropLast()
                amount = x + "$"
            }
        } else if newValue.count < oldValue.count {
            amount = newValue + "$"
        } else if newValue.contains("$") {
            let dropped = newValue.replacingOccurrences(of: "$", with: "")
            amount = dropped + "$"
        }
    }
}
