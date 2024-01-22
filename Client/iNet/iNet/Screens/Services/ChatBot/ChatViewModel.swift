//
//  ChatViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import Foundation
import NetSwift


struct DebateRequestBody: Codable {
    let message: String
}

// Struct for the response body
struct MessageResponse: Codable {
    let message: String
}

class ChatViewModel: ObservableObject {
    @Published var text = ""
    @Published var messages: [Message] = [
        Message(userType: .system, text: "Hello there! Ready to engage in a playful debate? Let's have some fun! What's on your mind?🤔"),
    ]
    
    func sendMessage(_ messageText: String) async {
        let urlString = "http://localhost:3000/api/assistant/debate"
        guard let url = URL(string: urlString) else { return }

        let message = DebateRequestBody(message: messageText)
        messages.append(Message(userType: .user, text: messageText))

        do {
            let (data, _) = try await NetworkManager.shared.postData(to: url, body: message)
            let messageResponse = try JSONDecoder().decode(MessageResponse.self, from: data)
            let receivedMessage = Message(userType: .system, text: messageResponse.message)
            
            DispatchQueue.main.async {
                self.messages.append(receivedMessage)
            }
        } catch {
            print("Error: \(error)")
            DispatchQueue.main.async {
                self.messages.append(Message(userType: .system, text: "Error: \(error.localizedDescription)"))
            }
        }
    }
}
