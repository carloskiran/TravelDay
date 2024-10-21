//
//  UtilClassTestCase.swift
//  TravelProTests
//
//  Created by MAC-OBS-48 on 06/09/23.
//

import XCTest
@testable import TravelPro

final class UtilClassTestCase: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        let _ = utilsClass.sharedInstance.isValidEmail(testStr: "test@yopmail.com")
        let _ = utilsClass.sharedInstance.isValidPassword(password: "Test@1234")
        let _ = utilsClass.sharedInstance.datesRange(from: Date(), to: Date())
        let _ = "test".multipleStringAndFont(firstString: "te", firstTextColor: .clear, secondString: "st", secondTextColor: .clear, firstTextFont: UIFont.systemFont(ofSize: 10.0), secondTextFont: UIFont.systemFont(ofSize: 10.0))
        let _ = "2023-01-01".toDate()
        let _ = "2023-01-01".getDate()
        let _ = "2023-01-01'T'00:00:00.000+00:00".singleConvertDateFormat()
        let _ = "2023-01-01'T'00:00:00.0000".timeStampAndDate()
        let _ = "2023-01-01 00:00:00".timeStampStringDate()
        let _ =  "2023-01-01 00:00:00".timeStampDateFormat
        let attr = NSMutableAttributedString(string: "This is test string")
        let _ =  attr.bold("This")
        let _ =  attr.normal("is")
        let _ =  attr.orangeHighlight("test")
        let _ =  attr.blackHighlight("string")
        let _ =  attr.underlined("test")
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
