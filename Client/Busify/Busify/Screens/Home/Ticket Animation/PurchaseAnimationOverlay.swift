//
//  PurchaseAnimationOverlay.swift
//  iNet
//
//  Created by Saba Gogrichiani on 04.02.24.
//

import SwiftUI

struct PurchaseAnimationOverlay: View {
    // MARK: - Properties
    @State private var dots = ""
    
    // MARK: - Body
    var body: some View {
        VStack {
            PurchaseView()
                .frame(width: 160, height: 160)
                .background(Color.background)
            
            
            Text("Processing\(dots)")
                .font(.custom("Poppins-semibold", size: 16))
                .foregroundColor(.white)
            
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(Color.background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .alternate, radius: 10, x: 0, y: 4)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                DispatchQueue.main.async {
                    self.dots.append(".")
                    if self.dots.count > 3 {
                        self.dots = ""
                    }
                }
            }
        }
        
    }
}

#Preview {
    PurchaseAnimationOverlay()
}
