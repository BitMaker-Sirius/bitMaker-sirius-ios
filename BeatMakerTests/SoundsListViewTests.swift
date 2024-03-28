//
//  SoundsListViewTests.swift
//  BeatMakerTests
//
//  Created by Павел on 28.03.2024.
//

import XCTest
@testable import BeatMaker

final class SoundsListViewTests: XCTestCase {
    var router: Router!

    override func setUpWithError() throws {
        router = Router(assembly: Assembly())
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testSoundIconInSoundsList() {
        let mainView = router.assembly.mainView()
        guard let project = mainView.viewModel.state.projectsList.first
        else { return }
        
        let soundsListView = router.assembly.soundsListView(projectId: project.id)
        guard let sound = soundsListView.viewModel.state.soundsList.first
        else { return }
        
        XCTAssertTrue(["🤪", "😎", "🤩", "🥳", "🥹", "😇", "🤯", "🤔"].contains(where: { sound.emoji == $0 }))
    }
}
