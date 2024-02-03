//
//  ProfileViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 01.02.24.
//

import Foundation
import NetSwift


final class ProfileViewModel {
    
    
    func deleteCard() async -> Void {
        guard let url = URL(string: "\(baseURL.production.rawValue)/api/card/delete") else { return }
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        
        let headers: [String: String] = ["Authorization": "Bearer \(token)", "Content-Type": "application/json"]
        
        do {
            let (_, _) = try await NetworkManager.shared.deleteDataWithHeaders(to: url, headers: headers)
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
            print("Error: \(error)")
        }
    }

}
