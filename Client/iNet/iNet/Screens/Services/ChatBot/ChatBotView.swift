//
//  ChatBotView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 21.01.24.
//

import SwiftUI

struct ChatBotView: View {
    let circleSize: CGFloat = 140
    let offset: CGFloat = 105
    var body: some View {
        ZStack {
            Color(.background).ignoresSafeArea()
            VStack {
                heroImage
                WelcomeMessage
                servicesGrid
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top)
        }
    }
    
    private var heroImage: some View {
        Image("chatBot")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 176)
    }
    
    private var WelcomeMessage: some View {
        HStack(spacing: 12) {
            messageIcon
            welcomeText
            Spacer()
        }
        .padding()
        .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.accent))
        )
    }
    
    private var messageIcon: some View {
        Image(systemName: "ellipsis.message.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 36)
            .foregroundStyle(Color(.accent))
    }
    
    private var welcomeText: some View {
        VStack(alignment: .leading) {
            Text("Start Chat With AI")
                .font(.custom("Poppins-Medium", size: 20))
            Text("Ask What you want and get answers")
                .font(.custom("Poppins-Medium", size: 12))
        }
        .foregroundStyle(Color(.accent))
    }
    
    private var servicesGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: gridRows, spacing: 20) {
                ForEach(services, id: \.title) { service in
                    serviceCard(service)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
        }
    }
    
    private var gridRows: [GridItem] {
        Array(repeating: .init(.fixed(120), spacing: 20), count: 2)
    }
    
    private func serviceCard(_ service: Service) -> some View {
        VStack {
            Image(systemName: service.iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.accent))
            Text(service.title)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(Color.white)
        }
        .frame(width: 120, height: 120)
        .background(Color(.base))
        .cornerRadius(15)
        .onTapGesture {
            print("")
            NavigationManager.shared.navigateToChatBot()
        }
    }
}

struct Service {
    var title: String
    var iconName: String
}

let services: [Service] = [
    Service(title: "Debator", iconName: "person.2"),
    Service(title: "Music", iconName: "music.mic"),
    Service(title: "Play a game", iconName: "gamecontroller"),
    Service(title: "Book", iconName: "book"),
    Service(title: "Joke", iconName: "text.bubble"),
    Service(title: "Movie", iconName: "popcorn"),
]

#Preview {
    ChatBotView()
}
