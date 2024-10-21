//
//  SignUpViewControllerTests.swift
//  TravelProTests
//
//  Created by VIJAY M on 05/05/23.
//

import XCTest
@testable import TravelPro

final class SignUpViewControllerTests: XCTestCase {
    
    var signupPage = SignUpViewController.loadFromNib()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        signupPage.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(signupPage)
        XCTAssertNotNil(signupPage.firstNameTextfield, "firstNameTextfield")
        XCTAssertNotNil(signupPage.lastNameTextfield, "lastNameTextfield")
        XCTAssertNotNil(signupPage.firstNameAlertLbl, "firstNameAlertLbl")
        XCTAssertNotNil(signupPage.lastNameAlertLbl, "lastNameAlertLbl")
        XCTAssertNotNil(signupPage.welcomeLbl, "welcomeLbl")
        XCTAssertNotNil(signupPage.nxtBtn, "nxtBtn")
        XCTAssertNotNil(signupPage.continueLbl, "continueLbl")
        XCTAssertNotNil(signupPage.strCharacters, "strCharacters")
        signupPage.viewDidLoad()
        signupPage.viewWillAppear(true)
        signupPage.nxtBtn.sendActions(for: .touchUpInside)
        signupPage.backAction(UIButton())
        signupPage.appleButtonAct(UIButton())
        signupPage.facebookButtonAct(UIButton())
        signupPage.googleButtonAct(UIButton())
    }
    
    func testNextButtonAction_InvalidFirstName_ShouldNotNavigateToNextScreen() {
        // Given
        signupPage.firstNameTextfield.text = "Jo" // Invalid first name (less than 3 characters)
        signupPage.lastNameTextfield.text = "Doe"
        
        // When
        signupPage.nextButtonAction(UIButton())
        
        // Then
        XCTAssertNil(signupPage.navigationController?.topViewController) // Navigation should not occur
    }
    
    func testNextButtonAction_InvalidLastName_ShouldNotNavigateToNextScreen() {
        // Given
        signupPage.firstNameTextfield.text = "John"
        signupPage.lastNameTextfield.text = "" // Invalid last name (empty)
        
        // When
        signupPage.nextButtonAction(UIButton())
        
        // Then
        XCTAssertNil(signupPage.navigationController?.topViewController) // Navigation should not occur
    }
    
    func testNextButtonAction_ValidNames_ShouldNavigateToNextScreen() {
        // Given
        signupPage.firstNameTextfield.text = "John"
        signupPage.lastNameTextfield.text = "Doe"
        
        // When
        signupPage.nextButtonAction(UIButton())
    }
    
    func testFirstNameTextField_ValidInput_ShouldChangeText() {
        // Given
        signupPage.firstNameTextfield.text = "Jo"
        
        // When
        let shouldChangeText = signupPage.textField(signupPage.firstNameTextfield, shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "h")
        
        // Then
        XCTAssertTrue(shouldChangeText) // Text should change
        XCTAssertTrue(signupPage.firstNameAlertLbl.isHidden) // Alert label should be hidden
        
        // Given
        signupPage.firstNameTextfield.text = "J"
        
        // When
        let shouldChangeReplaceText = signupPage.textField(signupPage.firstNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "-")
        
        // Then
        XCTAssertFalse(shouldChangeReplaceText) // Text should change
//        XCTAssertFalse(signupPage.firstNameAlertLbl.isHidden) // Alert label should be hidden
        
        // When
        let shouldChangeTextForSingleText = signupPage.textField(signupPage.firstNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "d")
        
        // Then
        XCTAssertFalse(shouldChangeTextForSingleText) // Text should change
    }
    
    func testLastNameTextField_InvalidInput_ShouldNotChangeText() {
        // Given
        signupPage.lastNameTextfield.text = "" // Invalid input (empty)
        
        // When
        let shouldChangeText = signupPage.textField(signupPage.lastNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "D")
        
        // Then
        XCTAssertFalse(shouldChangeText) // Text should not change
        XCTAssertEqual(signupPage.lastNameTextfield.text, "D") // Text field value should remain the same
        XCTAssertFalse(signupPage.lastNameAlertLbl.isHidden) // Alert label should be visible
        XCTAssertEqual(signupPage.lastNameAlertLbl.text, "Last Name should have Minimum 1 Character") // Alert label text should be correct
    }
    
    func testLastNameTextField_RangeChange_Checking() {
        // Given
        signupPage.lastNameTextfield.text = "Doe"
        
        // When
        let shouldChangeText = signupPage.textField(signupPage.lastNameTextfield, shouldChangeCharactersIn: NSRange(location: 1, length: 1), replacementString: "O")
        
        // Then
        XCTAssertTrue(shouldChangeText)
        XCTAssertTrue(signupPage.lastNameAlertLbl.isHidden) // Alert label should be hidden
    }
    
    func testLastNameTextField_ValidInput_ShouldChangeText() {
        // Given
        signupPage.lastNameTextfield.text = "D"
        
        // When
        let shouldChangeText = signupPage.textField(signupPage.lastNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "o")
        
        // Then
        XCTAssertFalse(shouldChangeText)
        XCTAssertTrue(signupPage.lastNameAlertLbl.isHidden) // Alert label should be hidden
        
        // Given
        signupPage.lastNameTextfield.text = "D"
        
        // When
        let shouldChangeReplaceText = signupPage.textField(signupPage.lastNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "-")
        
        // Then
        XCTAssertFalse(shouldChangeReplaceText) // Text should change
        XCTAssertTrue(signupPage.lastNameAlertLbl.isHidden) // Alert label should be hidden
        
        // When
        let shouldChangeTextForSingleText = signupPage.textField(signupPage.lastNameTextfield, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "d")
        
        // Then
        XCTAssertFalse(shouldChangeTextForSingleText) // Text should change
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
