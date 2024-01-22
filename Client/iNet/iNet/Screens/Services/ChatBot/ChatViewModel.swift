//
//  ChatViewModel.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import Foundation
import NetSwift

class ChatViewModel: ObservableObject {
    @Published var text = ""
    @Published var messages: [Message] = [
        Message(userType: .system, text: "Hello there! Ready to engage in a playful debate? Let's have some fun! What's on your mind?🤔"),
    ]
    
    @MainActor
    func sendMessage() async {
        let urlString = "http://localhost:3000/api/assistant/debate"
        guard let url = URL(string: urlString) else { return }
        
        let message = DebateRequestBody(message: text)
        messages.append(Message(userType: .user, text: text))
        text = ""
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
