//
//  RegisterView.swift
//  Busify
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct RegisterScreen: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AuthViewModel
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            titleTextWrapper
            inputFields
            buttonWrapper
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 42)
        .background(Color.background)
    }
    
    // MARK: - Computed Properties
    private var titleTextWrapper: some View {
        HStack(spacing: 12) {
            UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20)
                .frame(width: 6)
                .foregroundColor(Color.alternate)
            
            VStack(alignment: .leading) {
                titleText
                Spacer()
                descriptionText
            }
        }
        .frame(maxHeight: 48)
    }
    
    private var titleText: some View {
        HStack {
            Text(LocalizedStringKey("enterDetails"))
                .foregroundStyle(.accent)
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size : 20))
            Spacer()
        }
    }
    
    private var descriptionText: some View {
        Text(LocalizedStringKey("quickAndEasy"))
            .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size : 16))
            .foregroundColor(Color.accentColor.opacity(0.5))
    }
    
    private var inputFields: some View {
        VStack(spacing: 16) {
            nameField
            emailField
            passwordField
            errorMessageView
        }
    }
    
    private var nameField: some View {
        HStack(spacing: 16) {
            StyledTextField(text: $viewModel.name, placeholder: "name", isSecure: false)
            StyledTextField(text: $viewModel.lastName, placeholder: "lastName", isSecure: false)
        }
    }
    
    private var emailField: some View {
        StyledTextField(text: $viewModel.email, placeholder: "email", isSecure: false)
    }
    
    private var passwordField: some View {
        StyledTextField(text: $viewModel.password, placeholder: "password", isSecure: true)
    }
    
    private var buttonWrapper: some View {
        VStack(spacing: 16) {
            nextButton
            appleRegisterButton
        }
    }
    
    private var nextButton: some View {
        StyledButton(buttonText: "next", buttonColor: viewModel.isNextButtonDisabled ? .accent.opacity(0.5) : Color.alternate, textColor: .white) {
            if !viewModel.isNextButtonDisabled {
                Task {
                    let registrationSuccess = await viewModel.registerUser()
                    if registrationSuccess {
                        NavigationManager.shared.navigateToVerification()
                    }
                }
            }
        }
        .disabled(viewModel.isNextButtonDisabled)
    }
    
    
    private var appleRegisterButton: some View {
        StyledButton(buttonText: "Sign up with Apple", buttonColor: .accent, textColor: .black, icon: "applelogo") {
            print("Apple Sign")
        }
    }
    
    private var errorMessageView: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
                    .animation(.easeInOut, value: viewModel.errorMessage)
            }
        }
    }
    
}

#Preview {
    RegisterScreen(viewModel: AuthViewModel())
}
