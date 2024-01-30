//
//  verificationView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct VerificationView: View {
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
        VStack(alignment: .leading, spacing: 14) {
            Text("OTP Verification")
                .foregroundStyle(.accent )
                .font(.custom("Poppins-semibold", size: 20))
            
            Text("Enter the verification code we just send on your email adress")
                .font(Font.custom("Poppins", size: 16))
                .foregroundColor(Color.accentColor.opacity(0.5))
        }
        .padding(.top, 32)
    }
    
    private var otpTextField: some View {
        OTPTextField(numberOfFields: 4, enterValue: $otpValue)
    }
    
    private var verifyButton: some View {
        StyledButton(buttonText: "Verify", buttonColor: otpValue.allSatisfy { !$0.isEmpty } ? Color.alternate : .accent.opacity(0.5), textColor: .white) {
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
            Text("Didn’t receive code? ")
                .font(Font.custom("Poppins", size: 14))
                .foregroundColor(.white.opacity(0.7))
            Text("Resend")
                .font(Font.custom("Poppins-Bold", size: 14))
                .foregroundColor(.white)
                .onTapGesture {
                    print("Resend tapped")
                    // TODO: - Resend Verification Code
                }
        }
    }
    
}

#Preview {
    VerificationView(signUpViewModel: AuthViewModel())
}
