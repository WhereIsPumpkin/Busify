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
                NotificationCenter.default.post(name: .didUpdateCurrentUser, object: nil)
            }
        }
    }
    
    func fetchUserInfo() async -> Void {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else {
            return /*false*/
        }
        
        guard let url = URL(string: "\(baseURL.production.rawValue)/api/user/info") else {
            print("Invalid URL")
            return /*false*/
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do { 
            let (data, response) = try await URLSession.shared.data(for: request)
            if let jsonString = String(data: data, encoding: .utf8) {
                   print("Received JSON string: \(jsonString)")
               }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error")
                return /*false*/
            }
            let user = try JSONDecoder().decode(User.self, from: data)
            print(user)
            self.currentUser = user
            return /*true*/
        } catch {
            print("Failed to fetch user info: \(error.localizedDescription)")
            return /*false*/
        }
    }
}
