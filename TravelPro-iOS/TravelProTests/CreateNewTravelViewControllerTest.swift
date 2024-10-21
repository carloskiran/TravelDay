//
//  CreateNewTravelViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 30/08/23.
//

import XCTest
@testable import TravelPro


final class CreateNewTravelViewControllerTest: XCTestCase {
    
    var create = CreateNewTravelViewController.loadFromNib()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        create.loadViewIfNeeded()
    }


    override func tearDownWithError() throws {
        
        XCTAssertNotNil(create)
        XCTAssertNotNil(create.tableView, "tableView")
        XCTAssertNotNil(create.scrollView, "scrollView")
        XCTAssertNotNil(create.overviewView, "overviewView")
        XCTAssertNotNil(create.fromTextfield, "fromTextfield")
        XCTAssertNotNil(create.toTextfield, "toTextfield")
        XCTAssertNotNil(create.alertThresholdTextfiled, "alertThresholdTextfiled")
        XCTAssertNotNil(create.travelTypeTextfiled, "travelTypeTextfiled")
        XCTAssertNotNil(create.definitionTextfield, "definitionTextfield")
        XCTAssertNotNil(create.startDateTextfield, "startDateTextfield")
        XCTAssertNotNil(create.endDateTextfield, "endDateTextfield")
        XCTAssertNotNil(create.fiscalStartTextfield, "fiscalStartTextfield")
        XCTAssertNotNil(create.fiscalEndTextfield, "fiscalEndTextfield")
        XCTAssertNotNil(create.taxableDaysTextfield, "taxableDaysTextfield")
        XCTAssertNotNil(create.travelNotesTextview, "travelNotesTextview")
        XCTAssertNotNil(create.othersTextfield, "othersTextfield")
        XCTAssertNotNil(create.othersView, "othersView")
        XCTAssertNotNil(create.fromTextfieldView, "fromTextfieldView")
        XCTAssertNotNil(create.toTextfieldView, "toTextfieldView")
        XCTAssertNotNil(create.startDateView, "startDateView")
        XCTAssertNotNil(create.endDateView, "endDateView")
        XCTAssertNotNil(create.travelTypeView, "travelTypeView")
        XCTAssertNotNil(create.definitionView, "definitionView")
        XCTAssertNotNil(create.alertThresholdView, "alertThresholdView")
        XCTAssertNotNil(create.fiscalEndView, "fiscalEndView")
        XCTAssertNotNil(create.fiscalStartView, "fiscalStartView")
        XCTAssertNotNil(create.maximumStayDayView, "maximumStayDayView")
        XCTAssertNotNil(create.createButton, "createButton")
        XCTAssertNotNil(create.backButton, "backButton")
        XCTAssertNotNil(create.travelNotesView, "travelNotesView")
        XCTAssertNotNil(create.tableviewHeightConstrain, "tableviewHeightConstrain")

        create.viewDidLoad()
        create.viewWillAppear(false)
        create.UnitTestCoverage()
    }
    
    func testTableViewCellConfiguration() {
        // Get a specific cell and verify its configuration

        create.tableView.register(UINib(nibName: AttachmentProgressTableViewCell.TableReuseIdentifier, bundle: nil),forCellReuseIdentifier: AttachmentProgressTableViewCell.TableReuseIdentifier)

        let indexPath = IndexPath(item: 0, section: 0)
        let cell = create.tableView(create.tableView, cellForRowAt: indexPath) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell)
        
        let indexPath2 = IndexPath(item: 0, section: 1)
        let cell2 = create.tableView(create.tableView, cellForRowAt: indexPath2) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell2)
        
        let indexPath3 = IndexPath(item: 0, section: 2)
        let cell3 = create.tableView(create.tableView, cellForRowAt: indexPath3) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell3)
        
        let indexPath4 = IndexPath(item: 0, section: 3)
        let cell4 = create.tableView(create.tableView, cellForRowAt: indexPath4) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell4)
        
        let indexPath5 = IndexPath(item: 0, section: 4)
        let cell5 = create.tableView(create.tableView, cellForRowAt: indexPath5) as? AttachmentProgressTableViewCell
        XCTAssertNotNil(cell5)
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
