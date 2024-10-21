//
//  TermsAndConditionTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 12/09/23.
//

import XCTest
@testable import TravelPro

final class TermsAndConditionTest: XCTestCase {
    var terms = TermsAndConditionViewController()

    override func setUpWithError() throws {
        try super.setUpWithError()
        terms = TermsAndConditionViewController.loadFromNib()
        terms.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(terms)
        XCTAssertNotNil(terms.webView, "webView")
       
        terms.viewDidLoad()
        terms.viewWillAppear(false)
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
