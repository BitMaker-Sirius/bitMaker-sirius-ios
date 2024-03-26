//
//  TrackEditorViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI


final class TrackEditorViewModel: TrackEditorViewModeling {
    @Environment(\.router) var router: Router
    
    @Published
    var state = TrackEditorViewState(
        shouldShowPause: false, 
        isPauseActive: "play.fill",
        choosenSoundId: nil,
        soundsArray: [
            Sound(audioFileId: nil, name: "baraban", emoji: "\u{1f600}"),
            Sound(audioFileId: nil, name: "baraban1", emoji: "\u{1f601}"),
            Sound(audioFileId: nil, name: "baraban2", emoji: "\u{1f602}"),
            Sound(audioFileId: nil, name: "baraban3", emoji: "\u{1f603}"),
            Sound(audioFileId: nil, name: "baraban4", emoji: "\u{1f614}"),
            Sound(audioFileId: nil, name: "baraban5", emoji: "\u{1f605}"),
            Sound(audioFileId: nil, name: "baraban6", emoji: "\u{1f606}")
        ]
    )
    
    
    func handle(_ event: PlayTrackViewEvent) {
        print("tap")
        switch event {
        case .tapButton:
            state.shouldShowPause.toggle()
            state.isPauseActive = (state.shouldShowPause ? "pause.fill": "play.fill")
        }
    }
    
    func setSelectedSound(at id: UUID) {
        state.choosenSoundId = id.uuidString
    }
    
    func areUuidsSimilar(id1: UUID, id2: String) -> Bool {
        return id1.uuidString == id2
    }
    
    init() {
        self.state = state
    }
    
    @Published var selectedSounds: [Sound] = []
    
    func addOrRemoveSound(_ sound: Sound) {
        if let index = selectedSounds.firstIndex(where: { $0.name == sound.name }) {
            selectedSounds.remove(at: index)
        } else {
            selectedSounds.append(sound)
        }
    }
    
    func isSoundSelected(_ sound: Sound) -> Bool {
        return selectedSounds.contains(where: { $0.name == sound.name })
    }
}
