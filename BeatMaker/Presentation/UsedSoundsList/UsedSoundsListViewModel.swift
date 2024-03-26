//
//  UsedSoundsListViewModel.swift
//  BeatMaker
//
//  Created by Тася Галкина on 25.03.2024.
//

import Foundation
import SwiftUI


final class UsedTreckViewModel: UsedTreckViewModeling {
    
    @Published
    var state = UsedTreckViewState(
        shouldDeleteTreck: false,
        isDelete: "trash.fill",
        choosenSoundId: nil,
        usedSoundsArray: [
            Track(sound: Sound(audioFileId: nil, name: "baraban0", emoji: "\u{1f600}"), points: []),
            Track(sound: Sound(audioFileId: nil, name: "baraban1", emoji: "\u{1f601}"), points: []),
            Track(sound: Sound(audioFileId: nil, name: "baraban2", emoji: "\u{1f602}"), points: []),
            Track(sound: Sound(audioFileId: nil, name: "baraban3", emoji: "\u{1f603}"), points: [])
        ]
    )
    
    func shouldDeleteTreck(index: String) {
        if Int(index)! >= 0 && Int(index)! < state.usedSoundsArray.count {
            state.usedSoundsArray.remove(at: Int(index)!)
        }
        
    }
    
    init() {
        self.state = state
    }
    
}
