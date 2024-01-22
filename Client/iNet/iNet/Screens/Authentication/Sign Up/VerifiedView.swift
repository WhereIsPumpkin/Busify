//
//  VerifiedView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct VerifiedView: View {
    // MARK: Properties
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 40) {
            heroImage
            textWrap
            finishButton
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 60)
    }
    
    // MARK: Computed Properties
    private var heroImage: some View {
        Image(.verified)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 220)
    }
    
    private var textWrap: some View {
        VStack(spacing: 12) {
            title
            description
        }
    }
    
    private var title: some View {
        Text("Verified")
            .foregroundStyle(.black)
            .font(.custom("Poppins-medium", size: 20))
    }
    
    private var description: some View {
        Text("Your account has been verified\nsuccessfully")
          .font(Font.custom("Poppins", size: 16))
          .multilineTextAlignment(.center)
          .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
          .frame(width: 331, alignment: .top)
    }
    
    private var finishButton: some View {
        StyledButton(buttonText: "Log In", buttonColor: Color("mainColor"), textColor: .white) {
            NavigationManager.shared.navigateToLogIn()
        }
    }
}

#Preview {
    VerifiedView()
}
