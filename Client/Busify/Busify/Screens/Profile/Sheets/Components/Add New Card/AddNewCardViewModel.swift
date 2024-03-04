//
//  AddNewCardViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 02.02.24.
//

import Foundation
import NetSwiftly

final class AddNewCardViewModel: ObservableObject {
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
            cardDate = ""
            return
        }
        
        let formattedString = String(format: "%02d/%02d", month, year % 100)
        cardDate = formattedString
    }
    
    func addNewCard() async -> Void {
        var request = URLRequestBuilder(baseURL: BaseURL.production.url).post("/api/card/add")
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let requestBody = Card(
            cardNumber: cardNumber,
            cardName: cardName,
            cardDate: cardDate,
            cardCVV: cardCVV
        )
        
        request.setBearerToken(token)
        
        do {
            try request.setJSONBody(requestBody)
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            completion!()
            try await Task.sleep(nanoseconds: 5_000_000_000)
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


