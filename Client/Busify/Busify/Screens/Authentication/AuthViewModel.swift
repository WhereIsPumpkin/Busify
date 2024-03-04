//
//  AuthViewModel.swift
//  Busify
//
//  Created by Saba Gogrichiani on 15.01.24.
//

import Foundation
//import NetSwift
import NetSwiftly

final class AuthViewModel: ObservableObject {
    // MARK: - Properties
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
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
            
            return true
        } catch {
            await handleError(error)
            return false
        }
    }
    
    //    private func sendLoginRequest(with loginDetails: LoginDetails) async throws -> (Data, URLResponse) {
    //        let url = URL(string: "\(BaseURL.production.rawValue)/api/user/login")!
    //        return try await NetworkManager.shared.postData(to: url, body: loginDetails)
    //    }
    
    private func handleResponse(data: Data, response: URLResponse) throws -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return try handleSuccessResponse(data: data)
        case 400...499:
            return handleErrorResponse(data: data)
        default:
            DispatchQueue.main.async { self.errorMessage = "Server error" }
            return false
        }
    }
    
    private func handleSuccessResponse(data: Data) throws -> Bool {
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        UserDefaults.standard.set(loginResponse.token, forKey: "userToken")
        UserSessionManager.shared.currentUser = loginResponse.user
        DispatchQueue.main.async { self.errorMessage = nil }
        return true
    }
    
    private func handleErrorResponse(data: Data) -> Bool {
        if let errorMessage = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async { self.errorMessage = errorMessage }
        } else {
            DispatchQueue.main.async { self.errorMessage = "Error occurred" }
        }
        return false
    }
    
    private func clearLoginCredentials() {
        email = ""
        password = ""
    }
    
    private func clearUserData() {
        name = ""
        lastName = ""
        email = ""
        password = ""
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
