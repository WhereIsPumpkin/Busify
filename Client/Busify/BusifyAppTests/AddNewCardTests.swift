//  AddNewCardTests.swift
//  iNetTests
//
//  Created by Saba Gogrichiani on 07.02.24.
//

import XCTest
@testable import Busify

final class AddNewCardTests: XCTestCase {

    var viewModel: AddNewCardViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = AddNewCardViewModel(completion: {})
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases for Card Validation
    func testCardValidationSuccess() {
        viewModel.cardNumber = "1234 5678 9123 4567"
        viewModel.cardName = "John Doe"
        viewModel.cardDate = "12/21"
        viewModel.cardCVV = "123"
        XCTAssertTrue(viewModel.addCardValidation(), "Card details should be valid.")
    }
    
    func testCardValidationFailure() {
        viewModel.cardNumber = "123456789123456"
        viewModel.cardName = ""
        viewModel.cardDate = "12/25"
        viewModel.cardCVV = "123"
        XCTAssertFalse(viewModel.addCardValidation(), "Card details should be invalid due to missing name and incorrect card number length.")
    }
}

