//
//  WelcomeCollectionViewCellTests.swift
//  TravelProTests
//
//  Created by VIJAY M on 05/05/23.
//

import XCTest
@testable import TravelPro

final class WelcomeCollectionViewCellTests: XCTestCase {
    
    var welcomeCell = WelcomeCollectionViewCell()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
//        welcomeCell = WelcomeCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        welcomeCell.layoutIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        XCTAssertNotNil(welcomeCell)
//        XCTAssertNotNil(welcomeCell.imageView, "welcomeLbl")
//        XCTAssertNotNil(welcomeCell.splashLabel, "appNameLbl")
//        XCTAssertNotNil(welcomeCell.splashDescriptionLabel, "descLbl")
//        welcomeCell.awakeFromNib()
//        welcomeCell.updateData("splashScreen", "Desc", "")
        
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
