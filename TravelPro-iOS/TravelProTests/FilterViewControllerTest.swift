//
//  FilterViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 06/09/23.
//

import XCTest
@testable import TravelPro

final class FilterViewControllerTest: XCTestCase {

    var filter = FilterTravelViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        filter.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(filter)
        XCTAssertNotNil(filter.countryTF, "countryTF")
        XCTAssertNotNil(filter.startDateTextfield, "startDateTextfield")
        XCTAssertNotNil(filter.endDateTextfield, "endDateTextfield")
        filter.viewDidLoad()
        filter.viewWillAppear(false)
        filter.unitTestcase()
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
