//
//  WelcomeLandingViewControllerTests.swift
//  TravelProTests
//
//  Created by VIJAY M on 04/05/23.
//

import XCTest
@testable import TravelPro

final class WelcomeLandingViewControllerTests: XCTestCase {
    
    let welcome = WelcomeLandingViewController.loadFromNib()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        welcome.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(welcome)
        XCTAssertNotNil(welcome.welcomeLbl, "welcomeLbl")
        XCTAssertNotNil(welcome.appNameLbl, "appNameLbl")
        XCTAssertNotNil(welcome.descLbl, "descLbl")
        XCTAssertNotNil(welcome.loginBtn, "loginBtn")
        XCTAssertNotNil(welcome.signupBtn, "signupBtn")
        welcome.viewDidLoad()
        welcome.viewWillAppear(true)
        welcome.loginBtn.sendActions(for: .touchUpInside)
        welcome.signupBtn.sendActions(for: .touchUpInside)
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