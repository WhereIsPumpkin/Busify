//
//  AddNewCardViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 02.02.24.
//

import Foundation
import NetSwift

class AddNewCardViewModel: ObservableObject {
    // MARK: - Properties
    @Published var cardNumber = ""
    @Published var cardName = ""
    @Published var cardDate = ""
    @Published var cardCVV = ""
    
    func addNewCard() async -> Void {
        guard let url = URL(string: "\(baseURL.production.rawValue)/api/card/add-card") else { return }
        
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            return
        }
        
        let requestBody = Card(
            cardNumber: cardNumber,
            cardName: cardName,
            cardDate: cardDate,
            cardCVV: cardCVV
        )
        
        guard let httpBody = try? JSONEncoder().encode(requestBody) else {
            print("Failed to encode request body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
            // TODO: - Handle Error
            print("Error: \(error)")
        }
    }
    
    func updateCardNumber(with newValue: String, oldValue: String) {
        let nonSpaceCount = newValue.filter { $0 != " " }.count
        if nonSpaceCount % 4 == 0 && nonSpaceCount != 16 && nonSpaceCount != 0 && !newValue.hasSuffix(" ") {
            if newValue.count >= oldValue.count {
                DispatchQueue.main.async {
                    self.cardNumber = newValue + " "
                }
            }
        }
    }
    
    func updateCardDate(with newValue: String, oldValue: String) {
        if newValue.count == 2 && oldValue.count < newValue.count {
            DispatchQueue.main.async {
                self.cardDate = newValue + "/"
            }
        } else if newValue.count < oldValue.count && newValue.count == 2 {
            DispatchQueue.main.async {
                self.cardDate = String(newValue.dropLast())
            }
        }
        if newValue.count > 5 {
            DispatchQueue.main.async {
                self.cardDate = String(newValue.prefix(5))
            }
        }
    }
    
}


