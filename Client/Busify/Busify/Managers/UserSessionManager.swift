//
//  UserSessionManager.swift
//  iNet
//
//  Created by Saba Gogrichiani on 31.01.24.
//

import Foundation

class UserSessionManager {
    static let shared = UserSessionManager()
    
    private init() {}
    
    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didUpdateUser, object: nil)
            }
        }
    }
    
    func fetchUserInfo() async -> Void {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            return
        }
        
        guard let url = URL(string: "\(BaseURL.production.rawValue)/api/user/info") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url) 
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do { 
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }
            let user = try JSONDecoder().decode(User.self, from: data)
            self.currentUser = user
            return
        } catch {
            print("Failed to fetch user info: \(error.localizedDescription)")
            return
        }
    }
}
