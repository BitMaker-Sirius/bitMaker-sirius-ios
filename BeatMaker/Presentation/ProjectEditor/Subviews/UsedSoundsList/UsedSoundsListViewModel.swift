//
//  UsedSoundsListViewModel.swift
//  BeatMaker
//
//  Created by Тася Галкина on 25.03.2024.
//

import Foundation
import SwiftUI


final class UsedTrackViewModel: UsedTrackViewModeling {
    
    @Published
    var state = UsedTrackViewState()
    
    func shouldDeleteTrack(id: String) {
        guard let index = state.usedSoundsArray.firstIndex(where: {$0.id == id}) else {
            return
        }
        state.usedSoundsArray.remove(at: index)
    }
    
    init() {
        self.state = state
    }
    
    func updateTracks(_ tracks: [Track]) {
        state.usedSoundsArray = tracks
    }
}
