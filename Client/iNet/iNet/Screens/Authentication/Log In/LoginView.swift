//
//  LoginView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct LoginView: View {
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
                Text("Login")
                    .foregroundStyle(.accent)
                    .font(.custom("Poppins-Bold", size: 24))
                
                Text("Log In to Access All Features")
                    .foregroundStyle(.accent.opacity(0.5))
                    .font(.custom("Poppins-medium", size: 14))
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
            Text("Email")
                .foregroundStyle(.accent)
                .font(.custom("Poppins-medium", size: 16))
            
            StyledTextField(text: $viewModel.email, placeholder: "Enter your email", isSecure: false)
        }
    }
    
     private var passwordField: some View {
        VStack(alignment: .trailing, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .foregroundStyle(.accent)
                    .font(.custom("Poppins-medium", size: 16))
                
                StyledTextField(text: $viewModel.password, placeholder: "Enter Password", isSecure: true)
            }
            
            Button(action: {
                // TODO: Forgot Password
            }, label: {
                Text("Forgot Password?")
                    .foregroundStyle(.accent.opacity(0.8))
                    .font(.custom("Poppins", size: 12))
            })
        }
    }
    
    private var loginButton: some View {
        StyledButton(buttonText: "Log In", buttonColor: Color(.alternate), textColor: .white) {
            Task {
                let isSuccess = await viewModel.loginUser()
                if isSuccess {
                    NavigationManager.shared.navigateToMainViewScreen()
                } else {
                    // TODO: - Handle Login Error
                }
            }
        }
    }
    
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
