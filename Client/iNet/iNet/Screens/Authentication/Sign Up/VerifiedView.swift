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
        .background(Color.background)
    }
    
    // MARK: Computed Properties
    private var heroImage: some View {
        Image(.verified)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 220)
    }
    
    private var textWrap: some View {
        HStack  {
            VStack(alignment: .leading, spacing: 12) {
                title
                description
            }
            Spacer()
        }
    }
    
    private var title: some View {
        Text("Verified")
            .foregroundStyle(.accent)
            .font(.custom("Poppins-semibold", size: 24))
    }
    
    private var description: some View {
        Text("Your account has been verified\nsuccessfully")
          .font(Font.custom("Poppins", size: 12))
          .foregroundColor(Color.accentColor.opacity(0.5))
    }
    
    private var finishButton: some View {
        StyledButton(buttonText: "Log In", buttonColor: Color.alternate, textColor: .white) {
            NavigationManager.shared.navigateToLogIn()
        }
    }
}

#Preview {
    VerifiedView()
}
