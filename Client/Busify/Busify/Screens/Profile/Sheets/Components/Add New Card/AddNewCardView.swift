//
//  AddNewCardView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 01.02.24.
//

import SwiftUI

struct AddNewCardView: View {
    @StateObject var viewModel: AddNewCardViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isShowingScanner = false
    
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
            cardForm
            saveButton
            Spacer()
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }
    
    private var title: some View {
        Text(LocalizedStringKey("addCardTitle"))
            .font(.custom("Poppins-medium", size: 18))
            .foregroundStyle(.white)
    }
    
    private var cardForm: some View {
        VStack(spacing: 16) {
            cardNumberInput
            cardNameInput
            cardDateAndCVV
        }
        .foregroundStyle(.white)
    }
    
    private var cardNumberInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "creditcard")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
            
            TextField("", text: $viewModel.cardNumber.max(19), prompt: Text(LocalizedStringKey("cardNumber")).foregroundStyle(.white.opacity(0.5)))
                .keyboardType(.numberPad)
                .font(.custom("Poppins-medium", size: 14))
                .onChange(of: viewModel.cardNumber) { oldValue, newValue in
                    viewModel.updateCardNumber(with: newValue, oldValue: oldValue)
                }
            
            Image(systemName: "creditcard.viewfinder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.accent)
                .frame(height: 22)
                .onTapGesture {
                    isShowingScanner = true
                }
                .sheet(isPresented: $isShowingScanner) {
                    CardScannerView(completion: { card in
                        viewModel.cardNumber = card.number ?? ""
                        viewModel.cardName = card.name ?? ""
                        viewModel.expireDateComponents = card.expireDate
                    }, dismissAction: {
                        isShowingScanner = false
                    })
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
    
    private var cardNameInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
            
            TextField("", text: $viewModel.cardName, prompt: Text(LocalizedStringKey("cardName")).foregroundStyle(.white.opacity(0.5)))
                .keyboardType(.alphabet)
                .font(.custom("Poppins-medium", size: 14))
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
    
    private var cardDateAndCVV: some View {
        HStack {
            dateInput
            cvvInput
        }
    }
    
    private var dateInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
            
            TextField("", text: $viewModel.cardDate, prompt: Text(LocalizedStringKey("monthYear")).foregroundStyle(.white.opacity(0.5)))
                .onChange(of: viewModel.cardDate) { oldValue, newValue in
                    viewModel.updateCardDate(with: newValue, oldValue: oldValue)
                }
                .keyboardType(.numberPad)
                .font(.custom("Poppins-medium", size: 14))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(height: 44)
        .foregroundStyle(.white)
        .background(Color(red: 67/255, green: 69/255, blue: 73/255))
        .overlay( RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray, lineWidth: 1) )
    }
    
    private var cvvInput: some View {
        HStack(spacing: 12) {
            Image(systemName: "creditcard.and.123")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
            
            TextField("", text: $viewModel.cardCVV.max(3), prompt: Text("CVV").foregroundStyle(.white.opacity(0.5)))
                .font(.custom("Poppins-medium", size: 14))
                .keyboardType(.numberPad)
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
    
    private var saveButton: some View {
        Button(action: {
            Task {
                dismiss()
                await viewModel.addNewCard()
            }
        }, label: {
            saveButtonLabel
        })
        .padding(.top, 16)
        .disabled(!viewModel.addCardValidation())
    }
    
    private var saveButtonLabel: some View {
        HStack {
            Spacer()
            Text(LocalizedStringKey("save"))
                .foregroundStyle(.white)
                .font(.custom("Poppins-semibold", size: 16))
            Spacer()
        }
        .frame(height: 44)
        .background(viewModel.addCardValidation() ? Color.alternate : .gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


