//
//  CreatePsswordViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 31/08/23.
//

import XCTest
@testable import TravelPro

final class CreatePsswordViewControllerTest: XCTestCase {

    var password = CreatePasswordViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        password.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(password)
        XCTAssertNotNil(password.titleLabel, "titleLabel")
        XCTAssertNotNil(password.descriptionLabel, "descriptionLabel")
        XCTAssertNotNil(password.confirmPasswordTextfield, "confirmPasswordTextfield")
        XCTAssertNotNil(password.newPasswordTextfield, "newPasswordTextfield")
        XCTAssertNotNil(password.resetPasswordButton, "resetPasswordButton")
        XCTAssertNotNil(password.newPasswordAlrtLbl, "newPasswordAlrtLbl")
        XCTAssertNotNil(password.confirmPasswordAlrtLbl, "confirmPasswordAlrtLbl")
        XCTAssertNotNil(password.newPasswordeyeBtn, "newPasswordeyeBtn")
        XCTAssertNotNil(password.confirmPasswordEyeBtn, "confirmPasswordEyeBtn")
        XCTAssertNotNil(password.smilyImgView, "smilyImgView")
        XCTAssertNotNil(password.strenghtLbl, "strenghtLbl")
        XCTAssertNotNil(password.strengthDescLbl, "strengthDescLbl")
        XCTAssertNotNil(password.backBtnView, "backBtnView")

        password.viewDidLoad()
        password.viewWillAppear(false)
        password.unitTestcase()
        
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
