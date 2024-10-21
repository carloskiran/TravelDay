//
//  EditProfileViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 12/09/23.
//

import XCTest
@testable import TravelPro

final class EditProfileViewControllerTest: XCTestCase {
    var edit = EditProfileViewController()

    override func setUpWithError() throws {
        try super.setUpWithError()
        edit = EditProfileViewController.loadFromNib()
        edit.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        XCTAssertNotNil(edit)
        XCTAssertNotNil(edit.updateButtonLabel, "updateButtonLabel")
        XCTAssertNotNil(edit.firstNameAlrtLbl, "firstNameAlrtLbl")
        XCTAssertNotNil(edit.lastNameAlrtLbl, "lastNameAlrtLbl")
        XCTAssertNotNil(edit.emailAlrtLbl, "emailAlrtLbl")
        XCTAssertNotNil(edit.aboutYouAlrtLbl, "aboutYouAlrtLbl")
        XCTAssertNotNil(edit.addressAlrtLbl, "addressAlrtLbl")
        XCTAssertNotNil(edit.phoneAlrtLbl, "phoneAlrtLbl")
        XCTAssertNotNil(edit.genderAlrtLbl, "genderAlrtLbl")
        XCTAssertNotNil(edit.dobAlrtLbl, "dobAlrtLbl")
        XCTAssertNotNil(edit.firstNameTxtFld, "firstNameTxtFld")
        XCTAssertNotNil(edit.lastNameTxtFld, "lastNameTxtFld")
        XCTAssertNotNil(edit.emailTxtFld, "emailTxtFld")
        XCTAssertNotNil(edit.aboutTxtFld, "aboutTxtFld")
        XCTAssertNotNil(edit.countryTxtFld, "countryTxtFld")
        XCTAssertNotNil(edit.phoneTxtFld, "phoneTxtFld")
        XCTAssertNotNil(edit.dobTxtFld, "dobTxtFld")
        XCTAssertNotNil(edit.genderTxtFld, "genderTxtFld")
        XCTAssertNotNil(edit.addressTxtFld, "addressTxtFld")
        XCTAssertNotNil(edit.profileImage, "profileImage")
        XCTAssertNotNil(edit.btnCountry, "btnCountry")
        XCTAssertNotNil(edit.btnCountryPicker, "btnCountryPicker")
        XCTAssertNotNil(edit.countryArrowDropDown, "countryArrowDropDown")
        XCTAssertNotNil(edit.preferenceCollection, "preferenceCollection")
        XCTAssertNotNil(edit.preferenceCollectionHeight, "preferenceCollectionHeight")
        XCTAssertNotNil(edit.totalHeight, "totalHeight")

        edit.viewDidLoad()
        edit.viewWillAppear(false)
        edit.unitTestcase()
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
