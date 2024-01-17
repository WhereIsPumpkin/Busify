//
//  SignUpViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import Foundation
import NetSwift

enum baseURL: String {
    case local = "https://dull-ruby-python.cyclic.app"
    case production = "http://localhost:3000"
}

final class AuthViewModel: ObservableObject {
    //MARK: - Properties
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var selectedGender = Gender.female
    
    //MARK: - Methods
    var isNextButtonDisabled: Bool {
        name.isEmpty || lastName.isEmpty || !isValidEmail(email) || password.count < 6
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    func registerUser() async {
        let url = URL(string: "\(baseURL.production.rawValue)/api/user/register")!
        let user = User(name: name, lastName: lastName, email: email, password: password, gender: selectedGender, verified: false)
        do {
            let (_, response) = try await NetworkManager.shared.postData(to: url, body: user)
            print("User registered with response: \(response)")
        } catch {
            print("Failed to register user: \(error)")
        }
    }
    
    func verifyUser(with token: String) async -> Bool {
        let url = URL(string: "\(baseURL.production.rawValue)/api/user/verify")!
        let emailToken = EmailToken(email: email, token: token)
        do {
            let (_, response) = try await NetworkManager.shared.postData(to: url, body: emailToken)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("User registered with response: \(response)")
                return true
            } else {
                print("Failed to verify user: \(response)")
                return false
            }
        } catch {
            print("Failed to verify user: \(error.localizedDescription)")
            return false
        }
    }
    
}


