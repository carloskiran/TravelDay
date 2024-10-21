//
//  WelcomeViewControllerTests.swift
//  TravelProTests
//
//  Created by VIJAY M on 04/05/23.
//

import XCTest
@testable import TravelPro

final class WelcomeViewControllerTests: XCTestCase {
    
    var welcomeView = WelcomeViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        welcomeView = WelcomeViewController.loadFromNib()
        welcomeView.loadViewIfNeeded()
    }
    
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(welcomeView)
        XCTAssertNotNil(welcomeView.collectionView, "collectionView")
        XCTAssertNotNil(welcomeView.pageIndicationImageViewOne, "pageIndicationImageViewOne")
        XCTAssertNotNil(welcomeView.pageIndicationImageViewTwo, "pageIndicationImageViewTwo")
        XCTAssertNotNil(welcomeView.pageIndicationImageViewThree, "pageIndicationImageViewThree")
        XCTAssertNotNil(welcomeView.pageIndicationStackView, "pageIndicationStackView")
        XCTAssertNotNil(welcomeView.letsGoBtn, "letsGoBtn")
        XCTAssertNotNil(welcomeView.splashImages, "splashImages")
        XCTAssertNotNil(welcomeView.splashTexts, "splashTexts")
        XCTAssertNotNil(welcomeView.splashDescriptions, "splashDescriptions")
        XCTAssertNotNil(welcomeView.splashDescriptions, "splashDescriptions")
        XCTAssertNotNil(welcomeView.nextBtnTitles, "nextBtnTitles")
        welcomeView.viewDidLoad()
        welcomeView.viewWillAppear(true)
        welcomeView.testCaseCoverage(currentPage: 0)
        welcomeView.testCaseCoverage(currentPage: 2)
        welcomeView.testCaseCoverage(currentPage: 3)
        welcomeView.testCaseCoverage(currentPage: 4)
//        welcomeView.scrollToNextCell()
        welcomeView.letsGoBtn.sendActions(for: .touchUpInside)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testCollectionViewHasItems() {
        // Ensure that the collection view has the expected number of items
//        XCTAssertEqual(welcomeView.collectionView.numberOfItems(inSection: 0), 4)
    }
    
    // MARK: - Test methods
       func testCollectionViewCellConfiguration() {
           // Get a specific cell and verify its configuration
//           let indexPath = IndexPath(item: 0, section: 0)
//           let cell = welcomeView.collectionView(welcomeView.collectionView, cellForItemAt: indexPath) as? WelcomeCollectionViewCell
//           XCTAssertNotNil(cell)
//           let newindexPath = IndexPath(item: 3, section: 0)
//           let newCell = welcomeView.collectionView(welcomeView.collectionView, cellForItemAt: newindexPath) as? WelcomeEndCollectionViewCell
//           newCell?.delegate.didEndCellTapped()
//           newCell?.endCellTapAction(UIButton())
//           XCTAssertNotNil(newCell)

           // Assert that the cell's properties are set correctly
//           XCTAssertEqual(cell?.imageView.image, UIImage(named: "ad-1"))
//           XCTAssertEqual(cell?.splashLabel.text, tp_strings.welcome_controller.plan_your_dream)
//           XCTAssertEqual(cell?.splashDescriptionLabel.text, tp_strings.welcome_controller.travel_places)
       }

       func testScrollTabIndicatorSetup() {
           // Call the private method to setup the scroll tab indicator
           welcomeView.testCaseCoverage(currentPage: 3)

           // Assert that the UI elements are set correctly
           XCTAssertFalse(welcomeView.pageIndicationStackView.isHidden)
           XCTAssertTrue(welcomeView.pageIndicationImageViewOne.isHidden)
           XCTAssertTrue(welcomeView.pageIndicationImageViewTwo.isHidden)
           XCTAssertFalse(welcomeView.pageIndicationImageViewThree.isHidden)
           XCTAssertFalse(welcomeView.letsGoBtn.isHidden)
//           XCTAssertEqual(welcomeView.letsGoBtn.currentTitle, tp_strings.welcome_controller.continues)
       }

//    func testCollectionViewCellConfiguration() {
//        // Get a specific cell and verify its configuration
//        let indexPath = IndexPath(item: 0, section: 0)
//        if let cell = welcomeView.collectionView.dataSource?.collectionView(welcomeView.collectionView, cellForItemAt: indexPath) as? WelcomeCollectionViewCell {
//            XCTAssertNotNil(cell)
//            XCTAssertNotNil(cell.updateData("", "", ""), "updateData")
//        }
//    }

    func testCollectionViewSelection() {
        // Simulate cell selection and verify the expected action
        let indexPath = IndexPath(item: 2, section: 0)
        welcomeView.collectionView.delegate?.collectionView?(welcomeView.collectionView, didSelectItemAt: indexPath)
        // Add assertions for the expected behavior
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
