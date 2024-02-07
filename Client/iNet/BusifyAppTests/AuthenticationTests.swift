//
//  AuthenticationTests.swift
//  authenticationTests
//
//  Created by Saba Gogrichiani on 07.02.24.
//

import XCTest
@testable import iNet

final class AuthenticationTests: XCTestCase {
    
    var viewModel: AuthViewModel!
    
    // MARK: - Setup and Teardown
    override func setUpWithError() throws {
        super.setUp()
        viewModel = AuthViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases for Email Validation
    func testEmailValidation() {
        let validEmails = ["email@example.com", "firstname.lastname@example.com", "email@subdomain.example.com", "firstname+lastname@example.com", "1234567890@example.com", "email@example-one.com", "_______@example.com", "email@example.name", "email@example.museum", "email@example.co.jp", "firstname-lastname@example.com"]
        let invalidEmails = ["plainaddress", "@no-local-part.com", "Outlook Contact <outlook-contact@domain.com>", "no-at-sign", "no-tld@domain", ";beginning-semicolon@domain.co.uk", "middle-semicolon@domain.co;uk", "trailing-semicolon@domain.com;", "\"email\"@example.com", "email@domain.com (Joe Smith)", "email@-domain.com", "email@111.222.333.44444", "email@domain..com"]
        
        validEmails.forEach { email in
            XCTAssertTrue(viewModel.isValidEmail(email), "\(email) should be recognized as a valid email")
        }
        
        invalidEmails.forEach { email in
            XCTAssertFalse(viewModel.isValidEmail(email), "\(email) should be recognized as an invalid email")
        }
    }
    
    // MARK: - Test Cases for Next Button State
    func testNextButtonStateWithVariousInputs() {
        viewModel.name = "John"
        viewModel.lastName = "Doe"
        viewModel.email = "valid@example.com"
        viewModel.password = "validPassword123"
        XCTAssertFalse(viewModel.isNextButtonDisabled, "Next button should be enabled with all valid inputs")
        
        viewModel.email = "invalid@"
        XCTAssertTrue(viewModel.isNextButtonDisabled, "Next button should be disabled with an invalid email")
        viewModel.email = "valid@example.com"
        
        viewModel.password = "short"
        XCTAssertTrue(viewModel.isNextButtonDisabled, "Next button should be disabled with a password shorter than 6 characters")
        viewModel.password = "validPassword123"
        
        viewModel.name = ""
        XCTAssertTrue(viewModel.isNextButtonDisabled, "Next button should be disabled when name is empty")
        viewModel.name = "John"
        
        viewModel.lastName = ""
        XCTAssertTrue(viewModel.isNextButtonDisabled, "Next button should be disabled when last name is empty")
        viewModel.lastName = "Doe"
        
        viewModel.password = "123456"
        XCTAssertFalse(viewModel.isNextButtonDisabled, "Next button should be enabled with minimal valid password length")
        viewModel.password = "validPassword123"
        
        viewModel.email = "user+name@example.com"
        XCTAssertFalse(viewModel.isNextButtonDisabled, "Next button should be enabled with email containing allowed special characters")
        viewModel.email = "valid@example.com"
        
        viewModel.email = "invalid@"
        viewModel.password = "short"
        viewModel.name = ""
        viewModel.lastName = ""
        XCTAssertTrue(viewModel.isNextButtonDisabled, "Next button should be disabled with multiple invalid fields")
    }
}




