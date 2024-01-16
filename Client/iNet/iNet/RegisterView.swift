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
                .foregroundColor(Color(red: 0.31, green: 0.31, blue: 0.92))
            
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
                .foregroundStyle(Color("mainColor"))
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
            TextField("", text: $name, prompt: Text("Name").foregroundStyle(.gray))
                .padding(16)
                .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.05), lineWidth: 1)
                )
            
            TextField("", text: $lastName, prompt: Text("Last name").foregroundStyle(.gray))
                .padding(16)
                .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.05), lineWidth: 1)
                )
        }
    }
    
    private var emailField: some View {
        TextField("", text: $email, prompt: Text("Email").foregroundStyle(.gray))
            .padding(16)
            .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.03))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.05), lineWidth: 1)
            )
    }
    
    private var passwordField: some View {
        SecureField("", text: $password, prompt: Text("Password").foregroundStyle(.gray))
            .padding(16)
            .background(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.03))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.44, green: 0.44, blue: 0.44).opacity(0.05), lineWidth: 1)
            )
    }
    
    private var buttonWrapper: some View {
        VStack(spacing: 16) {
            nextButton
            appleRegisterButton
        }
    }
    
    private var nextButton: some View {
        Button(action: {
            navigateToSecondStage()
        }, label: {
            Text("Next")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color("mainColor"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        })
    }
    
    private var appleRegisterButton: some View {
        Button(action: {
            print("Text")
        }, label: {
            Label("Sign up with Apple", systemImage: "applelogo")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
        })
    }
}

#Preview {
    RegisterView(navigateToSecondStage: {})
}
