//
//  HomeView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 29.01.24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                Image(.profileImagePlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    HomeView()
}
