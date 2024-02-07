//
//  FillBalanceTests.swift
//  authenticationTests
//
//  Created by Saba Gogrichiani on 07.02.24.
//

import XCTest
@testable import iNet

final class FillBalanceViewModelTests: XCTestCase {

    var viewModel: FillBalanceViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = FillBalanceViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    func testUpdateAmount() {
        viewModel.updateAmount(oldValue: "", newValue: "5")
        XCTAssertEqual(viewModel.amount, "5₾", "Amount should be formatted with currency symbol.")
        
        viewModel.updateAmount(oldValue: "5₾", newValue: "50₾")
        XCTAssertEqual(viewModel.amount, "50₾", "Amount should update correctly with new value.")
        
        viewModel.updateAmount(oldValue: "50₾", newValue: "5₾")
        XCTAssertEqual(viewModel.amount, "5₾", "Amount should handle deletion correctly.")
    }
    
    func testValidateAmount() {
        viewModel.amount = "10₾"
        XCTAssertTrue(viewModel.validateAmount(), "Valid amount should return true.")
        XCTAssertEqual(viewModel.error, "", "There should be no error message for valid amount.")
        
        viewModel.amount = "-1₾"
        XCTAssertFalse(viewModel.validateAmount(), "Negative amount should be invalid.")
        XCTAssertNotEqual(viewModel.error, "", "There should be an error message for invalid amount.")
        
        viewModel.amount = "501₾"
        XCTAssertFalse(viewModel.validateAmount(), "Amount exceeding the limit should be invalid.")
        XCTAssertEqual(viewModel.error, "Max. limit: 500₾", "Error message should indicate max limit.")
    }
}

