//
//  EmailViewControllerTests.swift
//  TravelProTests
//
//  Created by VIJAY M on 05/05/23.
//

import XCTest
@testable import TravelPro

final class EmailViewControllerTests: XCTestCase {
    
    var email = EmailViewController.loadFromNib()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        email.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(email)
        XCTAssertNotNil(email.emailTextfield, "emailTextfield")
        XCTAssertNotNil(email.emailAlrtLbl, "emailAlrtLbl")
        XCTAssertNotNil(email.headingLbl, "headingLbl")
        XCTAssertNotNil(email.instructionLbl, "instructionLbl")
        XCTAssertNotNil(email.nxtBtn, "nxtBtn")
        XCTAssertNotNil(email.emailViewModel, "emailViewModel")
        XCTAssertNotNil(email.nxtBtn, "nxtBtn")
        XCTAssertNotNil(email.firstName, "firstName")
        XCTAssertNotNil(email.lastName, "lastName")
        email.viewDidLoad()
        email.nxtBtn.sendActions(for: .touchUpInside)
//        self.testMyViewControllerTextFieldDelegate()
    }
    
//    func testMyViewControllerTextFieldDelegate() {
//        if let textField = email.emailTextfield {
//
//            // Test textFieldShouldBeginEditing(_:)
//            XCTAssertTrue(textField.delegate?.textFieldShouldBeginEditing?(textField) ?? false)
//
//            // Test textFieldDidBeginEditing(_:)
//            textField.delegate?.textFieldDidBeginEditing?(textField)
//
//            // Test textFieldShouldEndEditing(_:)
//            XCTAssertTrue(textField.delegate?.textFieldShouldEndEditing?(textField) ?? false)
//
//            // Test textFieldDidEndEditing(_:)
//            textField.delegate?.textFieldDidEndEditing?(textField)
//
//            // Test textFieldDidEndEditing(_:reason:)
//            textField.delegate?.textFieldDidEndEditing?(textField, reason: .committed)
//
//            // Test textField(_:shouldChangeCharactersIn:replacementString:)
//            let range = NSRange(location: 0, length: 1)
//            let replacementString = "a"
//            XCTAssertTrue(textField.delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: replacementString) ?? false)
//
//            // Test textFieldShouldClear(_:)
//            XCTAssertTrue(textField.delegate?.textFieldShouldClear?(textField) ?? false)
//
//            // Test textFieldShouldReturn(_:)
//            XCTAssertTrue(textField.delegate?.textFieldShouldReturn?(textField) ?? false)
//        }
//    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
