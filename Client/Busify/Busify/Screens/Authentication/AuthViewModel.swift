import Foundation
import NetSwift

final class AuthViewModel: ObservableObject {
    // MARK: - Properties
    @Published var name = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    var isNextButtonDisabled: Bool {
        name.isEmpty || lastName.isEmpty || !email.isValidEmail || !password.isValidPassword
    }
    
    // MARK: - User Registration
    func registerUser() async -> Bool {
        let url = URL(string: "\(BaseURL.production.rawValue)/api/user/register")!
        let body = RegistrationDetails(name: name, lastName: lastName, email: email, password: password)
        
        do {
            let (data, response) = try await postRegistrationRequest(to: url, with: body)
            return handleResponse(response, data: data)
        } catch {
            handleErrorMessage("Failed to register user: \(error.localizedDescription)")
            return false
        }
    }
    
    private func postRegistrationRequest(to url: URL, with user: RegistrationDetails) async throws -> (Data, URLResponse) {
        return try await NetworkManager.shared.postData(to: url, body: user)
    }
    
    private func handleResponse(_ response: URLResponse, data: Data) -> Bool {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 201 {
                return true
            } else {
                if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = responseData["message"] as? String {
                    handleErrorMessage(message)
                } else {
                    handleErrorMessage("An error occurred.")
                }
                return false
            }
        }
        return false
    }
    
    private func handleErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }
    
    // MARK: - User Verification
    func verifyUser(with token: String) async -> Bool {
        let url = URL(string: "\(BaseURL.production.rawValue)/api/user/verify")!
        let emailToken = EmailToken(email: email, token: token)
        print(emailToken)
        defer {
            DispatchQueue.main.async {
                self.clearUserData()
            }
        }
        
        do {
            let (_, response) = try await NetworkManager.shared.postData(to: url, body: emailToken)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                return true
            } else {
                return false
            }
        } catch {
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
        
        let loginDetails = LoginDetails(email: email, password: password)
        
        do {
            let (data, response) = try await sendLoginRequest(with: loginDetails)
            let isSuccess = try handleResponse(data: data, response: response)
            if isSuccess {
                DispatchQueue.main.async {
                    self.clearLoginCredentials()
                    self.errorMessage = nil
                }
            }
            return isSuccess
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
            return false
        }
    }
    
    private func sendLoginRequest(with loginDetails: LoginDetails) async throws -> (Data, URLResponse) {
        let url = URL(string: "\(BaseURL.production.rawValue)/api/user/login")!
        return try await NetworkManager.shared.postData(to: url, body: loginDetails)
    }
    
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

struct ErrorResponse: Codable {
    let message: String
}
