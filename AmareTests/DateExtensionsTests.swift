//
//  DateExtensionsTests.swift
//  OnboardingTests
//
//  Created by Micheal Bingham on 6/25/23.
//

import XCTest
@testable import Amare

final class DateExtensionsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
	
	func testCombineWithTime() throws {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
		let timeZoneFormatter = DateFormatter()
		timeZoneFormatter.dateFormat = "ZZZZ"
		
		let testCases = [
			("1999/07/21 07:52", "America/Chicago", "1999/07/21 07:52 CDT"),
			("1989/03/30 11:20", "Europe/Minsk", "1989/03/30 11:20 MSK"),
			// add more test cases as needed
		]
		
		for (dateTime, timeZoneID, expected) in testCases {
			guard let date = dateFormatter.date(from: dateTime),
				  let timeZone = TimeZone(identifier: timeZoneID),
				  let expectedDate = dateFormatter.date(from: expected) else {
				XCTFail("Failed to setup test data for date: \(dateTime) and timezone: \(timeZoneID)")
				return
			}
			
			let result = date.combineWithTime(time: date, in: timeZone)
			XCTAssertEqual(result, expectedDate, "Failed for date: \(dateTime) and timezone: \(timeZoneID)")
		}
	}


}
