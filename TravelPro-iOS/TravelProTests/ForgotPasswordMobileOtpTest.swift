//
//  ForgotPasswordMobileOtpTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 04/09/23.
//

import XCTest
@testable import TravelPro

final class ForgotPasswordMobileOtpTest: XCTestCase {
    
    var forgot = ForgotPasswordMobileOtpViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        forgot.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        XCTAssertNotNil(forgot)
        XCTAssertNotNil(forgot.emailOTPView, "emailOTPView")
        XCTAssertNotNil(forgot.countDownLabel, "countDownLabel")
        XCTAssertNotNil(forgot.resendButton, "resendButton")
        XCTAssertNotNil(forgot.submitButton, "submitButton")

        forgot.viewDidLoad()
        forgot.viewWillAppear(false)
        forgot.unitTestcase()

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
