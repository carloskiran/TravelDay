//
//  MyTravelDetailSummaryViewcontrollerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 04/09/23.
//

import XCTest
@testable import TravelPro

final class MyTravelDetailSummaryViewcontrollerTest: XCTestCase {
    
    var summary = MyTravelDetailSummaryViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        summary.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(summary)
        XCTAssertNotNil(summary.titleLbl, "titleLbl")
        XCTAssertNotNil(summary.residentStatusLbl, "residentStatusLbl")
        XCTAssertNotNil(summary.residentStatusView, "residentStatusView")
        XCTAssertNotNil(summary.attachmentTableView, "attachmentTableView")
        XCTAssertNotNil(summary.travelNotesTxtView, "travelNotesTxtView")
        XCTAssertNotNil(summary.travelNotesTitleLbl, "travelNotesTitleLbl")
        XCTAssertNotNil(summary.travelNotesViewHeightConstraint, "travelNotesViewHeightConstraint")
        XCTAssertNotNil(summary.physicalPresenceDayCountLbl, "physicalPresenceDayCountLbl")
        XCTAssertNotNil(summary.physicalPresenceDayLbl, "physicalPresenceDayLbl")
        XCTAssertNotNil(summary.DepartureCountryName, "DepartureCountryName")
        XCTAssertNotNil(summary.DepartureTiming, "DepartureTiming")
        XCTAssertNotNil(summary.destinationCountryName, "destinationCountryName")
        XCTAssertNotNil(summary.destinationTiming, "destinationTiming")
        XCTAssertNotNil(summary.travelNoteView, "travelNoteView")

        summary.viewDidLoad()
        summary.viewWillAppear(false)
        summary.UnitTestcase()
    }
    
    func testCollectionViewCellConfiguration() {
        // Get a specific cell and verify its configuration
        
        summary.travelHotel = ["test/test.pdf"]
        summary.foodEntertainment = ["test/test.pdf"]
        summary.shoppingUtility = ["test/test.pdf"]
        summary.others = ["test/test.pdf"]
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = summary.tableView(summary.attachmentTableView, cellForRowAt: indexPath) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell)
        
        let indexPath2 = IndexPath(item: 0, section: 1)
        let cell2 = summary.tableView(summary.attachmentTableView, cellForRowAt: indexPath2) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell2)
        
        let indexPath3 = IndexPath(item: 0, section: 2)
        let cell3 = summary.tableView(summary.attachmentTableView, cellForRowAt: indexPath3) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell3)
        
        let indexPath4 = IndexPath(item: 0, section: 3)
        let cell4 = summary.tableView(summary.attachmentTableView, cellForRowAt: indexPath4) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell4)
        
        let indexPath5 = IndexPath(item: 0, section: 4)
        let cell5 = summary.tableView(summary.attachmentTableView, cellForRowAt: indexPath5) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell5)
        
        let didselect1 = IndexPath(item: 0, section: 0)
        summary.tableView(summary.attachmentTableView, didSelectRowAt: didselect1)
        
        let didselect2 = IndexPath(item: 0, section: 1)
        summary.tableView(summary.attachmentTableView, didSelectRowAt: didselect2)
        
        let didselect3 = IndexPath(item: 0, section: 2)
        summary.tableView(summary.attachmentTableView, didSelectRowAt: didselect3)
        
        let didselect4 = IndexPath(item: 0, section: 3)
        summary.tableView(summary.attachmentTableView, didSelectRowAt: didselect4)

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
