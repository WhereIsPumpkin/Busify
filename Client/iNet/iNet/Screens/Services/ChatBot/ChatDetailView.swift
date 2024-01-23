//
//  ChatDetailView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 22.01.24.
//

import SwiftUI

struct ChatDetailView: View {
    @StateObject var viewModel = ChatViewModel()
    @State private var isKeyboardVisible = false
    
    var body: some View {
        ZStack {
            backgroundColor
            contentView
        }
    }
    
    private var backgroundColor: some View {
        Color(.background).ignoresSafeArea()
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            chatScrollView
            Spacer()
            inputFieldWrapper
        }
        .keyboardResponsive { visible in
            isKeyboardVisible = visible
        }
        .ignoresSafeArea(edges: .bottom)
        .padding(.top)
    }
    
    private var chatScrollView: some View {
        ScrollView {
            messageList
        }
        .padding(.horizontal, 20)
    }
    
    private var messageList: some View {
        VStack {
            ForEach(viewModel.messages) { message in
                messageRow(message)
            }
        }
    }
    
    private func messageRow(_ message: Message) -> some View {
        HStack {
            if message.userType == .user {
                Spacer()
                userMessage(message.text)
            } else {
                programMessage(message.text)
                Spacer()
            }
        }
        
    }
    
    private func userMessage(_ text: String) -> some View {
        Text(text)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    private func programMessage(_ text: String) -> some View {
        Text(text)
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    private var inputFieldWrapper: some View {
        HStack(spacing: 16) {
            inputField
            sendButton
        }
        .frame(height: isKeyboardVisible ? 60 : 120)
        .padding(.horizontal, isKeyboardVisible ? 0 : 20)
        .padding(.trailing, isKeyboardVisible ? 20 : 0)
        .background(Color(.base))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: !isKeyboardVisible ? 30 : 14, topTrailingRadius: !isKeyboardVisible ? 30 : 14))
    }
    
    private var inputField: some View {
        TextField("", text: $viewModel.text, prompt: Text("Write Your Wrong Opinion Here!!").foregroundColor(Color(.accent).opacity(0.4)))
            .foregroundStyle(Color(.accent))
            .font(.custom("Poppins", size: 16))
            .padding(.horizontal)
            .frame(height: 50)
            .background(Color(.base))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color(.alternate))
            )
    }
    
    private var sendButton: some View {
        Button(action: {
            if !viewModel.text.isEmpty {
                Task {
                    await viewModel.sendMessage()
                }
            }
        }, label: {
            Image(systemName: "paperplane.fill")
                .foregroundStyle(Color(.alternate))
                .font(.system(size: 20))
        })
    }
}

#Preview {
    ChatDetailView()
}
