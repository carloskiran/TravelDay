//
//  LoginViewControllerTests.swift
//  TravelProTests
//
//  Created by VIJAY M on 04/05/23.
//

import XCTest
@testable import TravelPro

final class LoginViewControllerTests: XCTestCase {
    
    var welcomeView = LoginViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        welcomeView = LoginViewController.loadFromNib()
        welcomeView.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(welcomeView)
        XCTAssertNotNil(welcomeView.emailTextfield, "emailTextfield")
        XCTAssertNotNil(welcomeView.passwordTextfield, "passwordTextfield")
        XCTAssertNotNil(welcomeView.erremaillbl, "erremaillbl")
        XCTAssertNotNil(welcomeView.errpasswordlbl, "errpasswordlbl")
        XCTAssertNotNil(welcomeView.btnshowPasswordOutlet, "btnshowPasswordOutlet")
        XCTAssertNotNil(welcomeView.welcomeLbl, "welcomeLbl")
        XCTAssertNotNil(welcomeView.nxtBtn, "nxtBtn")
        XCTAssertNotNil(welcomeView.continueLBl, "continueLBl")
        XCTAssertNotNil(welcomeView.forgotBtn, "forgotBtn")
        XCTAssertNotNil(welcomeView.signupBtn, "signupBtn")
        XCTAssertNotNil(welcomeView.signupBtn, "signupBtn")
        welcomeView.viewDidLoad()
        welcomeView.viewWillAppear(true)
        welcomeView.nxtBtn.sendActions(for: .touchUpInside)
        welcomeView.forgotBtn.sendActions(for: .touchUpInside)
        welcomeView.signupBtn.sendActions(for: .touchUpInside)
        welcomeView.backAction(UIButton())
        welcomeView.facebookButtonAct(UIButton())
        welcomeView.googleButtonAct(UIButton())
        welcomeView.appleButtonAct(UIButton())
        welcomeView.clearAllFields()
        var facebookDetailsDict = NSMutableDictionary()
        facebookDetailsDict.setValue("traveltaxday@yopmail.com", forKey: "email")
        facebookDetailsDict.setValue("traveltax", forKey: "first_name")
        facebookDetailsDict.setValue("day", forKey: "last_name")
        facebookDetailsDict.setValue("9876kjhg0987", forKey: "id")
        welcomeView.faceBookLoginConfigurations(dataValues: (facebookDetailsDict.mutableCopy() as? NSDictionary)!)
        welcomeView.btnSecure_Act(UIButton())
        welcomeView.passwordTextfield.isSecureTextEntry = false
        welcomeView.btnSecure_Act(UIButton())
        welcomeView.emailTextfield.text = "traveltaxday@yopmail.com"
        guard let emailTextfield = welcomeView.emailTextfield else { return }
        _ = welcomeView.updateErrorData(emailTextfield)
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
