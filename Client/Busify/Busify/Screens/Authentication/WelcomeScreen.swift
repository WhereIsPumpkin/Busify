//
//  WelcomeView.swift
//  Busify
//
//  Created by Saba Gogrichiani on 15.01.24.
//

import SwiftUI

struct WelcomeScreen: View {
    // MARK: - Properties
    @ObservedObject var signUpViewModel: AuthViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            welcomeImage
            Spacer().frame(height: 20)
            welcomeText
            Spacer().frame(height: 48)
            authButtons
            Spacer()
        }
        .background(Color.background)
        .padding(.horizontal, 20)
    }
    
    // MARK: - Computed Properties
    private var welcomeImage: some View {
        Image(.welcomeHero)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 275)
    }
    
    private var welcomeText: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                Text("Busify")
                    .foregroundStyle(.accent)
                    .font(.custom("Poppins-Bold", size: 22))
                Spacer()
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStringKey("welcomeTitle-string"))
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .bold).font(size: Locale.current.language.languageCode?.identifier == "en" ? 22 : 20))
                    .minimumScaleFactor(0.6)
                    .foregroundColor(Color(.accent))
                
                Text(LocalizedStringKey("welcomeDescription-string"))
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .medium).font(size: Locale.current.language.languageCode?.identifier == "en" ? 14 : 12))
                    .foregroundStyle(Color(.accent).opacity(0.5))
            }
        }
    }
    
    private var authButtons: some View {
        VStack(spacing: 32) {
            StyledButton(buttonText: "login", buttonColor: Color(.alternate), textColor: .white) {
                NavigationManager.shared.navigateToLogIn()
            }
            
            StyledButton(buttonText: "register", buttonColor: .clear, textColor: .accent) {
                NavigationManager.shared.navigateToSignUp()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.accent, lineWidth: 1)
            )
        }
    }
}

#Preview {
    WelcomeScreen(signUpViewModel: AuthViewModel())
}

