//
//  MyTravelDetailViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 05/09/23.
//

import XCTest
@testable import TravelPro

final class MyTravelDetailViewControllerTest: XCTestCase {

    var detail = MyTravelDetailViewController.loadFromNib()

    override func setUpWithError() throws {
        try super.setUpWithError()
        detail.loadViewIfNeeded()   
    }

    @IBOutlet weak var tripListTableView: UITableView!
    @IBOutlet weak var attachmentListTableView: UITableView!
    @IBOutlet weak var tripTableHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var tripListView: CustomViewShadow!
    @IBOutlet weak var expandCloseButton: UIButton!
    @IBOutlet weak var fscalendar: FSCalendar!
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var physicalPresenceLabel: UILabel!
    @IBOutlet weak var residentView: CustomView!
    @IBOutlet weak var residentLabel: UILabel!
    @IBOutlet weak var attachmentNoDataLabel: UILabel!
    
    override func tearDownWithError() throws {
        XCTAssertNotNil(detail)
        XCTAssertNotNil(detail.tripListTableView, "tripListTableView")
        XCTAssertNotNil(detail.tripListView, "tripListView")
        XCTAssertNotNil(detail.countryTitleLabel, "countryTitleLabel")
        XCTAssertNotNil(detail.totalDaysLabel, "totalDaysLabel")
        XCTAssertNotNil(detail.physicalPresenceLabel, "physicalPresenceLabel")
        XCTAssertNotNil(detail.residentView, "residentView")
        XCTAssertNotNil(detail.residentLabel, "residentLabel")

        detail.viewDidLoad()
        detail.viewWillAppear(false)
        detail.uniteTestcase()
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
