//
//  verificationView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct VerificationView: View {
    @State private var otpValue: [String] = Array(repeating: "", count: 4)
    
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
    }
    
    private var image: some View {
        Image("letter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 210)
    }
    
    private var textWrapper: some View {
        VStack(spacing: 14) {
            Text("Verification")
                .foregroundStyle(.black)
                .font(.custom("Poppins-semibold", size: 20))
            
            Text("Enter the verification code we just sent on your email.")
                .font(Font.custom("Poppins", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
        }
    }
    
    private var otpTextField: some View {
        OTPTextField(numberOfFields: 4, enterValue: $otpValue)
    }
    
    private var verifyButton: some View {
        StyledButton(buttonText: "Verify", buttonColor: Color("mainColor"), textColor: .white) {
            let otpString = otpValue.joined()
            print(otpString)
        }
        .padding(.top, 16)
    }
    
    private var resendButton: some View {
        Button(action: {
            print("resend")
        }) {
            Label("Resend Code", systemImage: "arrow.triangle.2.circlepath")
                .font(Font.custom("Poppins", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    VerificationView()
}