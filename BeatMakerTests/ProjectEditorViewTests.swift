//
//  ProjectEditorViewTests.swift
//  BeatMakerTests
//
//  Created by Павел on 28.03.2024.
//

import XCTest
@testable import BeatMaker

final class ProjectEditorViewTests: XCTestCase {
    var router: Router!

    override func setUpWithError() throws {
        router = Router(assembly: Assembly())
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testPlayPauseTrack() {
        let projectEditorView = router.assembly.projectEditorView(projectId: nil)
        projectEditorView.viewModel.handle(.tapPlay)
        
        XCTAssert(projectEditorView.viewModel.state.pauseState == "stop.fill")
    }
}
