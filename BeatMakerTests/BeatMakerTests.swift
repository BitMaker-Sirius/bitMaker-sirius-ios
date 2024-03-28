//
//  BeatMakerTests.swift
//  BeatMakerTests
//
//  Created by Павел on 28.03.2024.
//

import XCTest
@testable import BeatMaker

final class BeatMakerTests: XCTestCase {
    var router: Router!

    override func setUpWithError() throws {
        router = Router(assembly: Assembly())
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testTrackWasAdded() {
        let mainView = router.assembly.mainView()
        
        XCTAssert(!mainView.viewModel.state.isEditing)
    }
}
