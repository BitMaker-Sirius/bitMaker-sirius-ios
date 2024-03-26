//
//  SoundListViewModelProtocol.swift
//  BeatMaker
//
//  Created by Александр Бобрун on 22.03.2024.
//

import Foundation

protocol AllSoundsViewModelProtocol: ObservableObject {
    var state: AllSoundsViewState { get }

    func handle(_ event: AllSoundsViewEvent)
}

enum AllSoundsViewEvent {
    case tapAddToTrackButton
    case tapAddNewSoundButton
    case tapOnCellPlayButton
    case tapOnCell
    case deleteSound
    case editSoundName
    case editSoundEmoji
}

struct AllSoundsViewState {
    var addedToTrackSounds: [Sound]
    var allSounds: [Sound]
    var editingSoundId: UUID?
}
