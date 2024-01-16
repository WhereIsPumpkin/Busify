//
//  WelcomeView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 15.01.24.
//

import SwiftUI

struct WelcomeView: View {
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
            
            Button(action: {
                print("Text")
            }, label: {
                Text("Login")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color("mainColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            })
            
            Button(action: {
                self.navigateToSignUp()
            }, label: {
                Text("Sign Up")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
            })
            
        }
    }
}

#Preview {
    WelcomeView(navigateToSignUp: {})
}

