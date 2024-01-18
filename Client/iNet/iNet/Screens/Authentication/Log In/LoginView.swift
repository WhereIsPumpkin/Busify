//
//  LoginView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    var navigateToHomeScreen: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack {
            logo
            Spacer().frame(height: 5)
            title
            description
            Spacer().frame(height: 60)
            fieldWrap
            Spacer()
            loginButton
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
    }
    
    // MARK: - Computed Properties
    private var logo: some View {
        Text("iNet")
            .font(.custom("Poppins-semiBold", size: 40))
            .foregroundStyle(Color("mainColor"))
    }
    
    private var title: some View {
        Text("Welcome Back")
            .font(.custom("Poppins-Medium", size: 26))
    }
    
    private var description: some View {
        Text("sign in to access your account")
            .font(.custom("Poppins", size: 14))
            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
    }
    
    private var fieldWrap: some View {
        VStack(spacing: 26) {
            emailField
            passwordField
        }
    }
    
    private var emailField: some View {
        StyledTextField(text: $viewModel.email, placeholder: "Email", isSecure: false)
    }
    
    private var passwordField: some View {
        VStack(alignment: .trailing, spacing: 16) {
            StyledTextField(text: $viewModel.password, placeholder: "Password", isSecure: true)
            
            Button(action: {
                navigateToHomeScreen()
            }, label: {
                Text("Forgot password?")
                    .font(.custom("Poppins", size: 12))
            })
        }
    }
    
    private var loginButton: some View {
        StyledButton(buttonText: "Log In", buttonColor: Color("mainColor"), textColor: .white) {
            Task {
                await viewModel.loginUser()
            }
            navigateToHomeScreen()
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(), navigateToHomeScreen: {})
}
