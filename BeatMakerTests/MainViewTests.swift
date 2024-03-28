//
//  MainViewTests.swift
//  BeatMakerTests
//
//  Created by Павел on 28.03.2024.
//

import XCTest
@testable import BeatMaker

final class MainViewTests: XCTestCase {
    var router: Router!

    override func setUpWithError() throws {
        router = Router(assembly: Assembly())
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testProjectsListNotEditingAtStart() {
        let mainView = router.assembly.mainView()
        
        XCTAssertFalse(mainView.viewModel.state.isEditing)
    }
}
