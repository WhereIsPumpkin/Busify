//
//  RegisterView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct RegisterView: View {
    
    @State var name = ""
    @State var lastName = ""
    @State var email = ""
    @State var password = ""
    var navigateToSecondStage: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            titleTextWrapper
            inputFields
            buttonWrapper
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 42)
    }

    private var titleTextWrapper: some View {
        HStack(spacing: 12) {
            UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 20)
                .frame(width: 6)
                .foregroundColor(Color("mainColor"))
            
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
            Text("Enter Your Details")
                .foregroundStyle(.black)
                .font(.custom("Poppins-semibold", size: 20))
            Spacer()
        }
    }
    
    private var descriptionText: some View {
        Text("it's quick and easy")
            .font(Font.custom("Poppins", size: 16))
            .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
    }
    
    private var inputFields: some View {
        VStack(spacing: 16) {
            nameField
            emailField
            passwordField
        }
    }
    
    private var nameField: some View {
        HStack(spacing: 16) {
            StyledTextField(text: $name, prompt: "Name", isSecure: false)
            StyledTextField(text: $lastName, prompt: "Last name", isSecure: false)
        }
    }

    private var emailField: some View {
        StyledTextField(text: $email, prompt: "Email", isSecure: false)
    }

    private var passwordField: some View {
        StyledTextField(text: $password, prompt: "Password", isSecure: true)
    }
    
    private var buttonWrapper: some View {
        VStack(spacing: 16) {
            nextButton
            appleRegisterButton
        }
    }
    
    private var nextButton: some View {
        StyledButton(buttonText: "Next", buttonColor: Color("mainColor"), textColor: .white) {
            navigateToSecondStage()
        }
    }

    private var appleRegisterButton: some View {
        StyledButton(buttonText: "Sign up with Apple", buttonColor: .black, textColor: .white, icon: "applelogo") {
            print("Apple Sign")
        }
    }

}

#Preview {
    RegisterView(navigateToSecondStage: {})
}
