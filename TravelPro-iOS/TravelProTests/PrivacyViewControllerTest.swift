//
//  PrivacyViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 06/09/23.
//

import XCTest
@testable import TravelPro

final class PrivacyViewControllerTest: XCTestCase {
    
    var privacy = PrivacyViewControllerViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        privacy.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        XCTAssertNotNil(privacy)
        XCTAssertNotNil(privacy.imgCondti1, "imgCondti1")
        XCTAssertNotNil(privacy.imgCondti2, "imgCondti2")
        XCTAssertNotNil(privacy.errorView, "errorView")
        XCTAssertNotNil(privacy.nextBtn, "nextBtn")
        XCTAssertNotNil(privacy.personalInfoDescriptionLabel, "personalInfoDescriptionLabel")
        XCTAssertNotNil(privacy.personalCollectInfoDescriptionLabel, "personalCollectInfoDescriptionLabel")
        XCTAssertNotNil(privacy.locationInfoDescriptionLabel, "locationInfoDescriptionLabel")
        XCTAssertNotNil(privacy.locationCollectDescriptionLabel, "locationCollectDescriptionLabel")

        privacy.viewDidLoad()
        privacy.viewWillAppear(false)
        privacy.unitTestcase()
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
