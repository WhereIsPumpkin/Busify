//
//  FillBalanceViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 03.02.24.
//

import Foundation
import NetSwift

final class FillBalanceViewModel: ObservableObject {
    @Published var amount = ""
    @Published var error = ""
    @Published var isValid = false
    
    func updateAmount(oldValue: String, newValue: String) {
        if !newValue.contains("₾") {
            if newValue.count == 1, !oldValue.contains("₾") {
                amount = newValue + "₾"
            } else if newValue.count != 0 {
                let x = newValue.dropLast()
                amount = x + "₾"
            }
        } else if newValue.count < oldValue.count {
            amount = newValue + "₾"
        } else if newValue.contains("₾") {
            let dropped = newValue.replacingOccurrences(of: "₾", with: "")
            amount = dropped + "₾"
        }
        
        self.isValid = validateAmount()
    }
    
    private func validateAmount() -> Bool {
        let amountWithoutSymbol = amount.dropLast()
        
        guard let amountNumber = Int(amountWithoutSymbol), amountNumber >= 0 else {
            self.error = "Enter a valid amount"
            return false
        }
        
        if amountNumber > 500 {
            self.error = "Max. limit: 500₾"
            return false
        }
        
        error = ""
        
        return true
    }
    
    func fillBalance() async {
        guard let url = URL(string: "\(BaseURL.production.rawValue)/api/balance/fill") else { return }
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let headers: [String: String] = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
        let currencysignRemovedAmount = amount.dropLast()
        guard let convertAmountToInt = Int(currencysignRemovedAmount) else { return }
        let requestBody = FillBalanceRequestBody(amountToAdd: convertAmountToInt)
        
        do {
            let _ = try await NetworkManager.shared.postDataWithHeaders(to: url, body: requestBody, headers: headers)
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
        
    }
}

struct FillBalanceRequestBody: Encodable {
    let amountToAdd: Int
}
