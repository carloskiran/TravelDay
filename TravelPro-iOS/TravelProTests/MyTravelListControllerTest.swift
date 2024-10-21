//
//  MyTravelListControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 01/09/23.
//

import XCTest
@testable import TravelPro

final class MyTravelListControllerTest: XCTestCase {
   
    var list = MyTravelListViewController.loadFromNib()


    override func setUpWithError() throws {
        try super.setUpWithError()
        list.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(list)
        XCTAssertNotNil(list.tableView, "tableView")
        XCTAssertNotNil(list.allButton, "allButton")
        XCTAssertNotNil(list.currentButton, "currentButton")
        XCTAssertNotNil(list.upcomingButton, "upcomingButton")
        XCTAssertNotNil(list.pastButton, "pastButton")
        XCTAssertNotNil(list.allSegmentImageView, "allSegmentImageView")
        XCTAssertNotNil(list.currentSegmentImageView, "currentSegmentImageView")
        XCTAssertNotNil(list.upcomingSegmentImageView, "upcomingSegmentImageView")
        XCTAssertNotNil(list.pastSegmentImageView, "pastSegmentImageView")
        XCTAssertNotNil(list.currentTitleLbl, "currentTitleLbl")
        XCTAssertNotNil(list.upcomingTitleLbl, "upcomingTitleLbl")
        XCTAssertNotNil(list.pastTitleLbl, "pastTitleLbl")

        list.viewDidLoad()
        list.viewWillAppear(false)
        list.unitTestcase()
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
