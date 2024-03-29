//
//  BeatMakerUITests.swift
//  BeatMakerUITests
//
//  Created by Павел on 28.03.2024.
//

import XCTest
@testable import BeatMaker

final class BeatMakerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
        try super.tearDownWithError()
    }

    func testMainView() throws {
        let createTrackButton = app.buttons["createTrackButton"]
        createTrackButton.tap()
        
        let projectEditorView = app.otherElements["projectEditorView"]
        XCTAssertTrue(projectEditorView.exists)
    }
}
