//
//  LoginView.swift
//  Busify
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct LoginScreen: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AuthViewModel
    
    // MARK: - Body
    var body: some View {
        VStack {
            logo
            Spacer().frame(height: 48)
            loginText
            Spacer().frame(height: 24)
            fieldWrap
            Spacer().frame(height: 24)
            loginButton
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 60)
        .background(Color.background)
    }
    
    // MARK: - Computed Properties
    private var logo: some View {
        HStack {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
            Text("Busify")
                .foregroundStyle(.accent)
                .font(.custom("Poppins-Bold", size: 32))
        }
    }
    
    private var loginText: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStringKey("loginTitle"))
                    .foregroundStyle(.accent)
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .bold).font(size: Locale.current.language.languageCode?.identifier == "en" ? 24 : 22))
                
                Text(LocalizedStringKey("login-description"))
                    .foregroundStyle(.accent.opacity(0.5))
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .medium).font(size: Locale.current.language.languageCode?.identifier == "en" ? 14 : 12))
            }
            Spacer()
        }
    }
    
    private var fieldWrap: some View {
        VStack(spacing: 16) {
            emailField
            passwordField
        }
    }
    
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey("email"))
                .foregroundStyle(.accent)
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .medium).font(size : 16))
            
            StyledTextField(text: $viewModel.email, placeholder: "email-enter", isSecure: false)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .trailing, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStringKey("password"))
                    .foregroundStyle(.accent)
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .medium).font(size : 16))
                
                StyledTextField(text: $viewModel.password, placeholder: "password-enter", isSecure: true)
            }
            
            HStack {
                errorMessageView
                
                Spacer()
                
                Button(action: {
                    // TODO: Forgot Password
                }, label: {
                    Text(LocalizedStringKey("forgot-password"))
                        .foregroundStyle(.accent.opacity(0.8))
                        .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size: 12))
                })
            }
        }
    }
    
    private var loginButton: some View {
        
        StyledButton(buttonText: "login", buttonColor: Color(.alternate), textColor: .white) {
            Task {
                let isSuccess = await viewModel.loginUser()
                if isSuccess {
                    NavigationManager.shared.navigateToMainViewScreen()
                }
            }
        }
    }
    
    private var errorMessageView: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                
            }
        }
    }
    
}

#Preview {
    LoginScreen(viewModel: AuthViewModel())
}
