//
//  ExportViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 30/08/23.
//

import XCTest
@testable import TravelPro

final class ExportViewControllerTest: XCTestCase {
    
    var export = ExportViewController.loadFromNib()
   
    override func setUpWithError() throws {
        try super.setUpWithError()
        export.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(export)
        XCTAssertNotNil(export.countryTextfield, "countryTextfield")
        XCTAssertNotNil(export.startDateTextfield, "startDateTextfield")
        XCTAssertNotNil(export.emailTextfield, "emailTextfield")
        XCTAssertNotNil(export.meCheckBtn, "meCheckBtn")
        XCTAssertNotNil(export.customCheckBtn, "customCheckBtn")
        XCTAssertNotNil(export.meEmailLbl, "meEmailLbl")
        XCTAssertNotNil(export.btnPDF, "btnPDF")
        XCTAssertNotNil(export.emailTypeView, "emailTypeView")
        XCTAssertNotNil(export.countryView, "countryView")
        XCTAssertNotNil(export.yearView, "yearView")

        export.viewDidLoad()
        export.viewWillAppear(false)
        export.unitTestcase()
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
