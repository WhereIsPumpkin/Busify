//
//  VerifiedView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 17.01.24.
//

import SwiftUI

struct VerifiedScreen: View {

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
        Text(LocalizedStringKey("verified"))
            .foregroundStyle(.accent)
            .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .semibold).font(size : 24))
    }
    
    private var description: some View {
        Text(LocalizedStringKey("verified-description"))
            .font(AppFont.forLanguage(Locale.current.language.languageCode?.identifier ?? "en", style: .regular).font(size : 12))
          .foregroundColor(Color.accentColor.opacity(0.5))
    }
    
    private var finishButton: some View {
        StyledButton(buttonText: "login", buttonColor: Color.alternate, textColor: .white) {
            NavigationManager.shared.navigateToLogIn()
        }
    }
}

#Preview {
    VerifiedScreen()
}
