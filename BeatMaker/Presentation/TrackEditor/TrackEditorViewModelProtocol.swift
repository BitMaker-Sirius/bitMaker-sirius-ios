//
//  TrackEditorViewModelProtocol.swift
//  BeatMaker
//
//  Created by Тася Галкина on 26.03.2024.
//

import Foundation

enum PlayTrackViewEvent {
    case tapButton
    case tapChervon
}

struct TrackEditorViewState {
    var shouldShowPause: Bool
    var pauseState: String
    var isChervonDown: Bool
    var chervonDirection: String
    var choosenSoundId: String?
    var soundsArray: [Sound]
}

protocol TrackEditorViewModeling: ObservableObject {
    var state: TrackEditorViewState { get }
    
    func handle(_ event: PlayTrackViewEvent)
    
    func setSelectedSound(at index: String)
    
    func areUuidsSimilar(id1: String, id2: String) -> Bool
    
}
