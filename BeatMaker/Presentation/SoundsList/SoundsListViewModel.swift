//
//  SoundListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

enum SoundsListViewEvent {
    case onLoadData(projectId: String)
    
    case tapBackButton
    case tapAddToTrackButton(sound: Sound)
    case tapAddNewSoundButton
    case tapOnCellPlayButton
    case tapOnCell
    case deleteSound(sound: Sound)
    case editSoundName
    case editSoundEmoji
}

struct SoundsListViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var project: Project?
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
    @Published var state = SoundsListViewState(
        indicatorViewState: .display,
        project: nil,
        soundsList: []
    )
    
    let projectProvider: ProjectProvider
    let soundsListProvider: SoundsListProvider
    
    init(projectProvider: ProjectProvider, soundsListProvider: SoundsListProvider) {
        self.projectProvider = projectProvider
        self.soundsListProvider = soundsListProvider
    }
    
    func handle(_ event: SoundsListViewEvent) {
        switch event {
        case .onLoadData(let projectId):
            loadData(projectId: projectId)
        case .tapBackButton:
            saveData()
            toProjectEditorView()
        case .deleteSound(let sound):
            deleteSound(sound: sound)
        case .tapAddToTrackButton(let sound):
            addToTrackButton(sound: sound)
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
    
    private func deleteSound(sound: Sound) {
        soundsListProvider.delete(by: sound.id) { [weak self] isCompleted in
            if isCompleted {
                if let index = self?.state.soundsList.firstIndex(where: { $0.id == sound.id }) {
                    self?.state.soundsList.remove(at: index)
                }
            }
        }
    }
    
    private func addToTrackButton(sound: Sound) {
        state.project?.preparedSounds.append(sound)
    }
    
    private func tapAddNewSoundButton() {
        let sound = Sound(audioFileId: nil, name: String(UUID().uuidString.prefix(5)), emoji: ["🤪", "😎", "🤩", "🥳", "🥹", "😇", "🤯", "🤔"].randomElement() ?? "😎")
        
        soundsListProvider.add(
            sound: sound
        ) { [weak self] isCompleted in
            if isCompleted {
                self?.state.soundsList.append(sound)
            } else {
                // Обработка ошибки
            }
        }
    }
    
    private func tapOnCellPlayButton() {
        
    }
    
    private func tapOnCell() {
        
    }
    
    private func editSoundName() {
        
    }
    
    private func editSoundEmoji() {
        
    }
    
    private func loadData(projectId: String) {
        state.indicatorViewState = .loading
        
        projectProvider.loadData(by: projectId) { [weak self] result in
            switch result {
            case .success(let project):
                self?.state.project = project
                self?.state.indicatorViewState = .display
            case .failure(_):
                self?.state.indicatorViewState = .error
            }
        }
        
        soundsListProvider.loadData { [weak self] result in
            switch result {
            case .success(let soundsList):
                self?.state.soundsList = soundsList
                self?.state.indicatorViewState = .display
            case .failure(_):
                self?.state.indicatorViewState = .error
            }
        }
    }
    
    private func saveData() {
        guard let project = state.project else {
            return
        }
        
        projectProvider.saveData(project: project) { isCompleted in
            // Обработать
        }
    }
    
    // MARK: Routing
    
    private func toProjectEditorView() {
        router.path.removeLast()
    }
}
