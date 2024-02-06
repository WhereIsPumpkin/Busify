//  CardScannerView.swift
//  iNet
//
//  Created by Saba Gogrichiani on 02.02.24.
//

import CreditCardScanner
import UIKit

final class CardScannerViewController: UIViewController, CreditCardScannerViewControllerDelegate {
    var completion: ((CreditCard) -> Void)?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentScanner()
    }

    private func presentScanner() {
        let creditCardScannerViewController = CreditCardScannerViewController(delegate: self)
        present(creditCardScannerViewController, animated: true)
    }

    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didErrorWith error: CreditCardScannerError) {
        dismiss(animated: true) {
            print(error.errorDescription ?? "Unknown error")
        }
    }

    func creditCardScannerViewController(_ viewController: CreditCardScannerViewController, didFinishWith card: CreditCard) {
        dismiss(animated: true) {
            self.completion?(card)
        }
    }
}



