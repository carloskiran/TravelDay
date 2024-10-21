//
//  UIHelperTestcase.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 06/09/23.
//

import XCTest
@testable import TravelPro

final class UIHelperTestcase: XCTestCase {


    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {

        let testTextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let testImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let testTableview = UITableView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))

        let _ = Button(backgroundColor: .clear, titleName: "test", titleColor: .clear, textFont: UIFont.systemFont(ofSize: 10))
        let _ = setupBackButton()
        let _ = ButtonImage(image: UIImage(systemName: "heart.fill"))
        let _ = testTextfield.userNameTextField()
        let _ = testTextfield.addRightPadding()
        let _ = testTextfield.addRightPaddingWithImageName("heart.fill")
        let _ = testImageview.makeBlurImageView()
        let _ = Label(textColor: .clear, textFont: UIFont.systemFont(ofSize: 10))
        let _ = SepratorLabel(backgroundColor: .clear)
        let _ = testTableview.setupBasicTableView()
        testImageview.roundCorners(corners: [.topLeft,.bottomRight], radius: 10.0)
        testTableview.reloadDataAndKeepOffset()
        testTableview.reloadWithoutAnimation()
        testTableview.reloadSectionWithoutAnimation(section: 0)
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        progressView.setAnimatedProgress()
        _ = UIWindow.isLandscape
        let _ = setupBaseView(.clear)
        let _ = setBoldText(withString: "test", boldString: "te", font: UIFont.systemFont(ofSize: 10))
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
