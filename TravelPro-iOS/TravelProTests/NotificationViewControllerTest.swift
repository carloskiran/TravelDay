//
//  NotificationViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 31/08/23.
//

import XCTest
@testable import TravelPro

final class NotificationViewControllerTest: XCTestCase {
    
    var notification = NotificationViewController.loadFromNib()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        notification.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(notification)
        XCTAssertNotNil(notification.titleLabel, "titleLabel")
        XCTAssertNotNil(notification.tableView, "tableView")
        XCTAssertNotNil(notification.backButton, "backButton")
        XCTAssertNotNil(notification.noMessageView, "noMessageView")
        XCTAssertNotNil(notification.sorryLbl, "sorryLbl")
        XCTAssertNotNil(notification.noRecordLbl, "noRecordLbl")

        notification.viewDidLoad()
        notification.viewWillAppear(false)
        notification.UnitTestcase()
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
