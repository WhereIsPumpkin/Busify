//
//  RegistrationSecondStageView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 16.01.24.
//

import SwiftUI

enum Gender: String, CaseIterable {
    case female = "Female"
    case male = "Male"
}

struct RegistrationSecondStageView: View {
    @State private var selectedGender = Gender.male
    var navigateToThirdStage: (() -> Void)
    
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
                    isMarked: selectedGender == gender,
                    callback: { selected in
                        selectedGender = Gender(rawValue: selected)!
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
        }
    }
}

#Preview {
    RegistrationSecondStageView(navigateToThirdStage: {})
}
