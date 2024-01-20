//
//  RegistrationSecondStageView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

struct RegistrationSecondStageView: View {
    // MARK: - Properties
    @ObservedObject var signUpViewModel: AuthViewModel
    var navigateToThirdStage: (() -> Void)
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            textWrapper
            genderSelection
            nextButton
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 42)
    }
    
    // MARK: - Computed Properties
    var textWrapper: some View {
        VStack(spacing: 8) {
            title
            description
        }
    }
    
    var title: some View {
        Text("What's your gender?")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.black)
            .font(.custom("Poppins-semibold", size: 20))
    }
    
    var description: some View {
        Text("You can change who sees your gender \nlater")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(Font.custom("Poppins", size: 16))
            .foregroundColor(Color(red: 0.44, green: 0.44, blue: 0.44))
    }
    
     var genderSelection: some View {
        VStack {
            ForEach(Gender.allCases, id: \.self) { gender in
                RadioButtonField(
                    id: gender.rawValue,
                    label: gender.rawValue,
                    isMarked: signUpViewModel.selectedGender == gender,
                    callback: { selected in
                        signUpViewModel.selectedGender = Gender(rawValue: selected)!
                    }
                )
                if gender != Gender.allCases.last {
                    Divider()
                }
            }
        }
    }
    
    private var nextButton: some View {
        StyledButton(buttonText: "Next", buttonColor: Color("mainColor"), textColor: .white) {
            navigateToThirdStage()
            Task {
                await signUpViewModel.registerUser()
            }
        }
    }
}

#Preview {
    RegistrationSecondStageView(signUpViewModel: AuthViewModel(), navigateToThirdStage: {})
}
