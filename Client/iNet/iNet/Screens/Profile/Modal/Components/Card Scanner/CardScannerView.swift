//
//  CardScannerView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 02.02.24.
//

import CreditCardScanner
import SwiftUI

struct CardScannerView: UIViewControllerRepresentable {
    var completion: ((CreditCard) -> Void)?
    var dismissAction: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, dismissAction: dismissAction)
    }
    
    class Coordinator: NSObject {
        var parent: CardScannerView
        var dismissAction: () -> Void
        
        init(_ parent: CardScannerView, dismissAction: @escaping () -> Void) {
            self.parent = parent
            self.dismissAction = dismissAction
        }
        
        func dismiss() {
            dismissAction()
        }
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let scannerViewController = CardScannerViewController()
        scannerViewController.completion = { card in
            self.completion?(card)
            context.coordinator.dismiss()
        }
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
