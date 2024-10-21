//
//  PhoneNumViewControllerTest.swift
//  TravelProTests
//
//  Created by VIJAY M on 05/05/23.
//

import XCTest
@testable import TravelPro

final class PhoneNumViewControllerTest: XCTestCase, UITextFieldDelegate {
    
    var phoneNo = PhoneNumViewController.loadFromNib()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        phoneNo.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(phoneNo)
        XCTAssertNotNil(phoneNo.phoneTextfield, "phoneTextfield")
        XCTAssertNotNil(phoneNo.phoneAlertLbl, "phoneAlertLbl")
        XCTAssertNotNil(phoneNo.headingLbl, "headingLbl")
        XCTAssertNotNil(phoneNo.instructionLbl, "instructionLbl")
        XCTAssertNotNil(phoneNo.submitBtn, "submitBtn")
        XCTAssertNotNil(phoneNo.countryLbl, "countryLbl")
        XCTAssertNotNil(phoneNo.countryImageView, "countryImageView")
        XCTAssertNotNil(phoneNo.phoneCodeAlertLbl, "phoneCodeAlertLbl")
        XCTAssertNotNil(phoneNo.phoneModel, "phoneModel")
        XCTAssertNotNil(phoneNo.email, "email")
        XCTAssertNotNil(phoneNo.firstName, "firstName")
        XCTAssertNotNil(phoneNo.lastName, "lastName")
        XCTAssertNotNil(phoneNo.resident, "resident")
        phoneNo.viewDidLoad()
        phoneNo.viewWillAppear(true)
        phoneNo.nextButtonAction(UIButton())
        phoneNo.backAction(UIButton())
        phoneNo.countrybtnAction(_sender: UIButton())
//        let demoCountry = Country(phoneCode: "+91", isoCode: "IND")
//        phoneNo.countryDetailsUpdate(country: demoCountry)
    }
    
    func testMyViewControllerTextFieldDelegate() throws {
        phoneNo.phoneTextfield.text = "123445678"
        
        // When
        let shouldChangeText = phoneNo.textField(phoneNo.phoneTextfield, shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "")
        
        // Then
        XCTAssertTrue(shouldChangeText) // Text should change
    }
    

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
