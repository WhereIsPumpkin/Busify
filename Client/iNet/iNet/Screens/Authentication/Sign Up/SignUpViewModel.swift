//
//  SignUpViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import Foundation
import NetSwift

final class SignUpViewModel: ObservableObject {
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var selectedGender = Gender.male
    
    func registerUser() async {
        let url = URL(string: "https://dull-ruby-python.cyclic.app/api/user/register")!
        let user = User(name: name, lastName: lastName, email: email, password: password, gender: selectedGender)
        do {
            let (_, response) = try await NetworkManager.shared.postData(to: url, body: user)
            print("User registered with response: \(response)")
        } catch {
            print("Failed to register user: \(error)")
        }
    }

    
}

