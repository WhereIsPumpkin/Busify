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
    var completion: (() -> Void)?
    
    var expireDateComponents: DateComponents? {
        didSet {
            updateCardDateString()
        }
    }
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    private func updateCardDateString() {
        guard let expireDateComponents = expireDateComponents,
              let month = expireDateComponents.month,
              let year = expireDateComponents.year else {
            cardDate = "" // Reset or handle as needed
            return
        }
        
        // Format the month and year to MM/YY
        let formattedString = String(format: "%02d/%02d", month, year % 100)
        cardDate = formattedString
    }
    
    func addNewCard() async -> Void {
        guard let url = URL(string: "\(baseURL.production.rawValue)/api/card/add") else { return }
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let requestBody = Card(
            cardNumber: cardNumber,
            cardName: cardName,
            cardDate: cardDate,
            cardCVV: cardCVV
        )
        
        let headers: [String: String] = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
        
        do {
            let (_, _) = try await NetworkManager.shared.postDataWithHeaders(to: url, body: requestBody, headers: headers)
            // Introduce a delay before fetching user info to simulate backend processing time
            completion!()
            try await Task.sleep(nanoseconds: 5_000_000_000) // 5 seconds delay
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
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
    
    func addCardValidation() -> Bool {
        if cardNumber.isEmpty || cardName.isEmpty || cardDate.isEmpty || cardCVV.isEmpty {
            return false
        }
        
        let nonDigitCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: " ")).inverted
        if cardNumber.rangeOfCharacter(from: nonDigitCharacters) != nil {
            return false
        }
        
        if cardNumber.count < 16 {
            return false
        }
        
        return true
    }
}


