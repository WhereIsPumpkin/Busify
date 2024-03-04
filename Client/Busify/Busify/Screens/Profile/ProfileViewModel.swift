//
//  ProfileViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 01.02.24.
//

import Foundation
import NetSwiftly

final class ProfileViewModel {
    
    func deleteCard() async -> Void {
        guard let token = UserDefaults.standard.string(forKey: "userToken") else { return }
        var request = URLRequestBuilder(baseURL: BaseURL.production.url).delete("/api/card/delete")
        request.setBearerToken(token)
        
        do {
            _ = try await NetSwiftly.shared.performRequest(request: request, responseType: Empty.self)
            await UserSessionManager.shared.fetchUserInfo()
        } catch {
            print("Error: \(error)")
        }
    }

}
