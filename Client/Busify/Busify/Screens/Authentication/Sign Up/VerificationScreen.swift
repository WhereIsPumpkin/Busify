//
//  verificationView.swift
//  Busify
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct VerificationScreen: View {
    // MARK: - Properties
    @ObservedObject var signUpViewModel: AuthViewModel
    @State private var otpValue: [String] = Array(repeating: "", count: 4)
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            image
            textWrapper
            otpTextField
            verifyButton
            resendButton
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.background)
    }
    
    // MARK: - Computed Properties
    private var image: some View {
        Image("letter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 210)
    }
    
    private var textWrapper: some View {
        HStack {
            VStack(alignment: .leading, spacing: 14) {
                Text(LocalizedStringKey("otpVerification"))
                    .foregroundStyle(.accent )
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size : 24))
                
                Text(LocalizedStringKey("otpDescription"))
                    .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size : 12))
                    .foregroundColor(Color.accentColor.opacity(0.5))
            }
            .padding(.top, 32)
            
            Spacer()
        }
    }
    
    private var otpTextField: some View {
        OTPTextField(numberOfFields: 4, enterValue: $otpValue)
    }
    
    private var verifyButton: some View {
        StyledButton(buttonText: "verify", buttonColor: otpValue.allSatisfy { !$0.isEmpty } ? Color.alternate : .accent.opacity(0.5), textColor: .white) {
            let token = otpValue.joined()
            Task {
                let isVerified = await signUpViewModel.verifyUser(with: token)
                if isVerified {
                    NavigationManager.shared.navigateToVerified()
                }
            }
        }
        .padding(.top, 16)
        .disabled(otpValue.allSatisfy { $0.isEmpty })
    }
    
    private var resendButton: some View {
        HStack(spacing: 0) {
            Text(LocalizedStringKey("no-receive"))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size : 14))
                .foregroundColor(.white.opacity(0.7))
            Text(LocalizedStringKey("resend"))
                .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .bold).font(size : 14))
                .foregroundColor(.white)
                .onTapGesture {
                    print("Resend tapped")
                    // TODO: - Resend Verification Code
                }
        }
    }
    
}

#Preview {
    VerificationScreen(signUpViewModel: AuthViewModel())
}
