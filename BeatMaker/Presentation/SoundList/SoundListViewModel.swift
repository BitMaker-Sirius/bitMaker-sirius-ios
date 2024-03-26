//
//  SoundListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

class SoundListViewModel: ObservableObject, AllSoundsViewModelProtocol {
    
    @Published var state = AllSoundsViewState(addedToTrackSounds: [], allSounds: [])
//    private var editorViewModel: TrackEditorViewModel = TrackEditorViewModel()
    
    func handle(_ event: AllSoundsViewEvent) {
        print(event)
        switch event {
        case .deleteSound:
            deleteSound()
        case .tapAddToTrackButton:
            tapAddToTrackButton()
        case .tapAddNewSoundButton:
            tapAddNewSoundButton()
        case .tapOnCellPlayButton:
            tapOnCellPlayButton()
        case .tapOnCell:
            tapOnCell()
        case .editSoundName:
            editSoundName()
        case .editSoundEmoji:
            editSoundEmoji()
        }
    }
    
    init(editorViewModel: TrackEditorViewModel, addedToTrackSounds: [Sound]) {
        state.addedToTrackSounds = addedToTrackSounds
        state.allSounds = [
            Sound(audioFileId: UUID().uuidString,
                  name: "first",
                  emoji: "\u{1f600}"),
            Sound(audioFileId: UUID().uuidString,
                  name: "first",
                  emoji: "\u{1f600}")
        ]
    }
    
    private func deleteSound() {
        
    }
    
    private func tapAddToTrackButton() {
        
    }
    
    private func tapAddNewSoundButton() {
        
    }
    
    private func tapOnCellPlayButton() {
        
    }
    
    private func tapOnCell() {
        
    }
    
    private func editSoundName() {
        
    }
    
    private func editSoundEmoji() {
        
    }
    
}
