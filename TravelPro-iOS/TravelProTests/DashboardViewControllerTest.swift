//
//  DashboardViewControllerTest.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 30/08/23.
//

import XCTest
@testable import TravelPro

final class DashboardViewControllerTest: XCTestCase {

    var home = DashBoardViewController.loadFromNib()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        home.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        XCTAssertNotNil(home)
//        XCTAssertNotNil(home.updateBtn, "updateBtn")
//        XCTAssertNotNil(home.profileupdateLbl, "profileupdateLbl")
        XCTAssertNotNil(home.profileImageView, "profileImageView")
//        XCTAssertNotNil(home.workDaysProgressView, "workDaysProgressView")
//        XCTAssertNotNil(home.nonWorkDaysProgressView, "nonWorkDaysProgressView")
//        XCTAssertNotNil(home.presenceDaysProgressView, "presenceDaysProgressView")
        XCTAssertNotNil(home.collectionView, "collectionView")
        XCTAssertNotNil(home.tableView, "tableView")
        XCTAssertNotNil(home.userNameLabel, "userNameLabel")
        XCTAssertNotNil(home.recentAllButton, "recentAllButton")
        XCTAssertNotNil(home.upcomingAllButton, "upcomingAllButton")
        XCTAssertNotNil(home.totalDaysLabel, "totalDaysLabel")
//        XCTAssertNotNil(home.daysCompletedLabel, "daysCompletedLabel")
//        XCTAssertNotNil(home.daysLeftLabel, "daysLeftLabel")
        XCTAssertNotNil(home.presenceDayLabel, "presenceDayLabel")
        XCTAssertNotNil(home.residentView, "residentView")
        XCTAssertNotNil(home.residentLabel, "residentLabel")
//        XCTAssertNotNil(home.totalDaysProgressLabel, "totalDaysProgressLabel")
//        XCTAssertNotNil(home.daysCompletedProgressLabel, "daysCompletedProgressLabel")
//        XCTAssertNotNil(home.daysLeftProgressLabel, "daysLeftProgressLabel")
        XCTAssertNotNil(home.presentCountryLabel, "presentCountryLabel")
        XCTAssertNotNil(home.noRecentVisitLabel, "noRecentVisitLabel")
        XCTAssertNotNil(home.noUpcomingScheduleLabel, "noUpcomingScheduleLabel")
        XCTAssertNotNil(home.noCurrentScheduleLabel, "noCurrentScheduleLabel")
        XCTAssertNotNil(home.notificationBtn, "notificationBtn")
        XCTAssertNotNil(home.notificationHighLightView, "notificationHighLightView")
        XCTAssertNotNil(home.updateNowViewHeightConstrain, "updateNowViewHeightConstrain")
        XCTAssertNotNil(home.updateNowProfileView, "updateNowProfileView")
        XCTAssertNotNil(home.currentScheduleCustomView, "currentScheduleCustomView")
        XCTAssertNotNil(home.currentDateStack, "currentDateStack")
        XCTAssertNotNil(home.pastDateStack, "pastDateStack")
        XCTAssertNotNil(home.lastDateStack, "lastDateStack")
        XCTAssertNotNil(home.currentDateLbl, "currentDateLbl")
        XCTAssertNotNil(home.currentDateSelectorView, "currentDateSelectorView")
        XCTAssertNotNil(home.pastDateLbl, "pastDateLbl")
        XCTAssertNotNil(home.pastDateSelectorView, "pastDateSelectorView")
        XCTAssertNotNil(home.lastDateLbl, "lastDateLbl")
        XCTAssertNotNil(home.lastDateSelectorView, "lastDateSelectorView")
        XCTAssertNotNil(home.locationContentView, "locationContentView")
        XCTAssertNotNil(home.locationDetectedView, "locationDetectedView")
        XCTAssertNotNil(home.confirmStayPopupView, "confirmStayPopupView")
        XCTAssertNotNil(home.countryFrom, "countryFrom")
        XCTAssertNotNil(home.currentLocationTextfield, "currentLocationTextfield")
        XCTAssertNotNil(home.startDateTextfield, "startDateTextfield")
        XCTAssertNotNil(home.confirmContentView, "confirmContentView")
        XCTAssertNotNil(home.confirmStayCurrentLocationView, "confirmStayCurrentLocationView")
        XCTAssertNotNil(home.confirmStayWhenDidyouArriveView, "confirmStayWhenDidyouArriveView")
        XCTAssertNotNil(home.confirmStayWhichCountryView, "confirmStayWhichCountryView")
        XCTAssertNotNil(home.confirmCurrentDateView, "confirmCurrentDateView")
        XCTAssertNotNil(home.countryNameView, "countryNameView")
        XCTAssertNotNil(home.whenDidYouArriveView, "whenDidYouArriveView")
        XCTAssertNotNil(home.fromWhichCountryView, "fromWhichCountryView")
        XCTAssertNotNil(home.currentDataFromConfirmStay, "currentDataFromConfirmStay")
        XCTAssertNotNil(home.currentCountryFromConfirmStay, "currentCountryFromConfirmStay")
        XCTAssertNotNil(home.travelDataArrivedFromConfirmStay, "travelDataArrivedFromConfirmStay")
        XCTAssertNotNil(home.countryArrivedFromConfirmStay, "countryArrivedFromConfirmStay")

        home.viewDidLoad()
        home.viewWillAppear(false)
        home.uniTestcase()
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
