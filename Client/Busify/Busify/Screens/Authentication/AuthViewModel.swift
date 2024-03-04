//
//  AuthViewModel.swift
//  Busify
//
//  Created by Saba Gogrichiani on 15.01.24.
//

import Foundation
import NetSwiftly

final class AuthViewModel: ObservableObject {
    // MARK: - Properties
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? {
        didSet {
            clearErrorMessage()
        }
    }
    
    private let baseURL = BaseURL.production.rawValue
    private let builder: URLRequestBuilder
    
    init() {
        guard let baseURL = URL(string: self.baseURL) else {
            fatalError("Invalid base URL")
        }
        self.builder = URLRequestBuilder(baseURL: baseURL)
    }
    
    // MARK: - Computed Properties
    var isNextButtonDisabled: Bool {
        name.isEmpty || lastName.isEmpty || !email.isValidEmail || !password.isValidPassword
    }
    
    // MARK: - User Registration
    func registerUser() async -> Bool {
        let body = RegistrationDetails(name: name, lastName: lastName, email: email, password: password)
        var request = builder.post("/api/user/register")
        
        do {
            try request.setJSONBody(body)
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            return true
        } catch let error as NetworkError {
            await handleError(error)
            return false
        } catch {
            await handleError(error)
            return false
        }
    }
    
    // MARK: - User Verification
    func verifyUser(with token: String) async -> Bool {
        let emailTokenBody = EmailToken(email: email, token: token)
        var request = builder.post("/api/user/verify")
        
        do {
            try request.setJSONBody(emailTokenBody)
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            await clearUserData()
            NetSwiftly.shared.debugEnabled = true
            return true
        } catch let error as NetworkError {
            await handleError(error)
            return false
        } catch {
            await handleError(error)
            return false
        }
    }
    
    // MARK: - User Login
    func loginUser() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Please fill in all fields."
            }
            return false
        }
        NetSwiftly.shared.debugEnabled = true
        let loginDetails = LoginDetails(email: email, password: password)
        var request = builder.post("/api/user/login")
        
        
        do {
            try request.setJSONBody(loginDetails)
            let loginResponse = try await NetSwiftly.shared.performRequest(request: request, responseType: LoginResponse.self)
            
            UserDefaults.standard.set(loginResponse.token, forKey: "userToken")
            UserSessionManager.shared.currentUser = loginResponse.user
            await clearUserData()
            
            return true
        } catch {
            await handleError(error)
            return false
        }
    }
}

extension AuthViewModel {
    @MainActor
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .serverMessage(let message):
                self.errorMessage = message
            default:
                self.errorMessage = "An unexpected network error occurred."
            }
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
}

// Helper funcs
extension AuthViewModel {
    @MainActor
    private func clearUserData() {
        name = ""
        lastName = ""
        email = ""
        password = ""
    }
    
    private func clearErrorMessage() {
        if errorMessage != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.errorMessage = nil
            }
        }
    }
}
