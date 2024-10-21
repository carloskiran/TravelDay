//
//  MyProfileViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 06/09/23.
//

import XCTest
@testable import TravelPro

final class MyProfileViewControllerTest: XCTestCase {

    var profile = MyProfileViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        profile.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(profile)
        XCTAssertNotNil(profile.userHiLabel, "userHiLabel")
        XCTAssertNotNil(profile.emailVerifiedButton, "emailVerifiedButton")
        XCTAssertNotNil(profile.scrollView, "scrollView")
        XCTAssertNotNil(profile.editButton, "editButton")
        XCTAssertNotNil(profile.editTitleLbl, "editTitleLbl")
        XCTAssertNotNil(profile.emailLbl, "emailLbl")
        XCTAssertNotNil(profile.mobileLbl, "mobileLbl")
        XCTAssertNotNil(profile.genderDOBLbl, "genderDOBLbl")
        XCTAssertNotNil(profile.profileImage, "profileImage")
        XCTAssertNotNil(profile.preferenceCollection, "preferenceCollection")

        profile.viewDidLoad()
        profile.viewWillAppear(false)
        profile.unitTestcase()
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
