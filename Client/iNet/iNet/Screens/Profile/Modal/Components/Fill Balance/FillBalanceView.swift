//
//  FillBalanceView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 01.02.24.
//

import SwiftUI

struct FillBalanceView: View {
    @StateObject var viewModel = FillBalanceViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            backgroundColor
            content
        }
    }
    
    private var backgroundColor: some View {
        Color.modal.ignoresSafeArea()
    }
    
    private var content: some View {
        VStack(spacing: 20) {
            title
            amountFieldWrap
            confirmButtonLabelButton
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }
    
    private var title: some View {
        Text("Top Up Balance")
            .font(.custom("Poppins-medium", size: 18))
            .foregroundStyle(.white)
    }
    
    private var amountFieldWrap: some View {
        VStack(alignment: .leading) {
            amountFieldTitle
            amountField
        }
    }
    
    private var amountFieldTitle: some View {
        Text("Amount")
            .font(.custom("Poppins-medium", size: 12))
            .foregroundStyle(.white)
    }
    
    private var amountField: some View {
        HStack(spacing: 12) {
            Image(systemName: "dollarsign.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
            
            TextField("", text: $viewModel.amount, prompt: Text("E.g 50$").foregroundStyle(.white.opacity(0.5)))
                .keyboardType(.numberPad)
                .font(.custom("Poppins-medium", size: 14))
                .onChange(of: viewModel.amount) { oldValue, newValue in
                    viewModel.updateAmount(oldValue: oldValue, newValue: newValue)
                }
            
            
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(height: 44)
        .foregroundStyle(.white)
        .background(Color(red: 67/255, green: 69/255, blue: 73/255))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    private var confirmButtonLabelButton: some View {
        Button(action: {
            Task {
                
                dismiss()
            }
        }, label: {
            confirmButtonLabel
        })
        .padding(.top, 16)
        
    }
    
    private var confirmButtonLabel: some View {
        HStack {
            Spacer()
            Text("Confirm")
                .foregroundStyle(.white)
                .font(.custom("Poppins-semibold", size: 16))
            Spacer()
        }
        .frame(height: 44)
        .background(Color.alternate)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    FillBalanceView()
}


