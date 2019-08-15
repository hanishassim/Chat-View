//
//  ChatViewUITests.swift
//  ChatViewUITests
//
//  Created by H on 15/08/2019.
//  Copyright © 2019 H. All rights reserved.
//

import XCTest

class ChatViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
    }
    
    func testAreYouThere() {
        let aytChatText = app.tables.cells.staticTexts["Are you there?"]
        
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: aytChatText, handler: nil)
        
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssert(aytChatText.exists)
    }
    
    func testChatBubbleDisplay() {
        app.otherElements.containing(.navigationBar, identifier:"Chat View").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
        
        app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let testChatText = app.tables.cells.staticTexts["Test"]
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: testChatText, handler: nil)
        
        app.buttons["Send"].tap()
        
        waitForExpectations(timeout: 3, handler: nil)
        XCTAssert(testChatText.exists)
    }
}
