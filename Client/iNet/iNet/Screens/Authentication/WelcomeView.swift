//
//  WelcomeView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 15.01.24.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var signUpViewModel: AuthViewModel
    var navigateToSignUp: (() -> Void)
    
    var body: some View {
        VStack {
            welcomeImage
            Spacer().frame(height: 20)
            welcomeText
            Spacer().frame(height: 48)
            authButtons
            Spacer()
            
        }
        .padding(20)
        .padding(.top, 50)
    }
    
    private var welcomeImage: some View {
        Image(.onlineConnect)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 250)
    }
    
    private var welcomeText: some View {
        VStack(spacing: 24) {
            Text("Connect, Share\n Explore")
                .foregroundStyle(Color("mainColor"))
                .font(.custom("Poppins-semibold", size: 32))
                .multilineTextAlignment(.center)
            
            Text("iNet: Connect, share, explore. Your global social gateway.")
                .foregroundStyle(.black)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
        }
    }
    
    private var authButtons: some View {
        VStack(spacing: 32) {
            StyledButton(buttonText: "Login", buttonColor: Color("mainColor"), textColor: .white) {
                print("Login")
            }
            
            StyledButton(buttonText: "Sign Up", buttonColor: .white, textColor: .black) {
                self.navigateToSignUp()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
        }
    }
    
}

#Preview {
    WelcomeView(signUpViewModel: AuthViewModel(), navigateToSignUp: {})
}

