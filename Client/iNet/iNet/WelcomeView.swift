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
            Spacer().frame(height: 50)
            welcomeText
            Spacer()
            authButtons
            Spacer()
            
        }
        .padding(16)
    }
    private var welcomeImage: some View {
        Image(.onlineConnect)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private var welcomeText: some View {
        VStack(spacing: 24) {
            Text("Connect, \n Share, Explore")
                .foregroundStyle(Color("mainColor"))
                .font(.system(size: 36, weight: .semibold))
                .multilineTextAlignment(.center)
            
            Text("iNet: Connect, share, explore. Your global social gateway.")
                .foregroundStyle(.black)
                .font(.system(size: 16, weight: .medium))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
    }
    
    private var authButtons: some View {
        HStack {
            
            Button(action: {
                print("Text")
            }, label: {
                Text("Login")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color("mainColor"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
            Spacer()
            
            Button(action: {
                self.navigateToSignUp()
            }, label: {
                Text("Register")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    WelcomeView(navigateToSignUp: { })
}

