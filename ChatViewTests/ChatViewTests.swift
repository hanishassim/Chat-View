//
//  ChatViewTests.swift
//  ChatViewTests
//
//  Created by H on 13/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import XCTest
@testable import ChatView

class ChatViewTests: XCTestCase {
    let formatter = DateFormatter()
    
    func testTimeAgoString() {
        let date1 = "2018-06-03T09:15:00.000Z"
        var dateDiffYear = convertTo8601(dateInString: date1)
        
        XCTAssertEqual(convertToCustomFormatDate(date: dateDiffYear), "Sun, 3 Jun 2018")
        
        let date2 = "2019-06-03T09:15:00.000Z"
        dateDiffYear = convertTo8601(dateInString: date2)
        
        XCTAssertEqual(convertToCustomFormatDate(date: dateDiffYear), "Mon, 3 Jun")
    }
    
    func testSendMessage() {
        let expectedMessage = "Hello World"
        
        // Define expectation
        let resultExpectation = expectation(description: "APIRequest does sendMesage and runs the callback closure")
        
        // Run code
        APIRequest(endpoint: "users").send(message: expectedMessage) { (result) in
            switch result {
            case .success(let chat):
                XCTAssertEqual(chat.message, expectedMessage)
                
                // Fulfill expectation in callback
                resultExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        // Wait for the expectation to fulfill
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout: \(error)")
            }
        }
    }
    
    fileprivate func convertTo8601(dateInString: String) -> Date {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: dateInString)!
    }
    
    fileprivate func convertToCustomFormatDate(date: Date) -> String {
        return date.printDayAndDate
    }
}
