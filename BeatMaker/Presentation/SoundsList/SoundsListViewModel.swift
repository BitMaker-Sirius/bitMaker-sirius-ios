//
//  SoundListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

enum SoundsListViewEvent {
    case tapBackButton
    case tapAddToTrackButton
    case tapAddNewSoundButton
    case tapOnCellPlayButton
    case tapOnCell
    case deleteSound
    case editSoundName
    case editSoundEmoji
}

struct SoundsListViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var soundsList: [Sound]
    
//    var addedToTrackSounds: [Sound]
//    var editingSoundId: UUID?
}

protocol SoundsListViewModel: ObservableObject {
    var state: SoundsListViewState { get }

    func handle(_ event: SoundsListViewEvent)
}

class SoundsListViewModelImp: SoundsListViewModel {
    @Environment(\.router) var router: Router
    @Published var state = SoundsListViewState(indicatorViewState: .display, soundsList: [])
    
    let projectProvider: ProjectProvider
    let soundsListProvider: SoundsListProvider
    
    init(projectProvider: ProjectProvider, soundsListProvider: SoundsListProvider) {
        self.projectProvider = projectProvider
        self.soundsListProvider = soundsListProvider
    }
    
    func handle(_ event: SoundsListViewEvent) {
        switch event {
        case .tapBackButton:
            toProjectEditorView()
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
    
    private func toProjectEditorView() {
        router.path.removeLast()
    }
}
