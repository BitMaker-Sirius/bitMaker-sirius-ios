//
//  TrackEditorViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

enum ProjectEditorViewEvent {
    case onLoadData(projectId: String?)
    
    case tapBackButton
    case tapVisualizationButton
    case tapAddSounds
    case tapButton
    case tapChervon
}

struct ProjectEditorViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var project: Project?
    
    var shouldShowPause: Bool
    var pauseState: String
    var isChervonDown: Bool
    var chervonDirection: String
    var choosenSoundId: String?
    var soundsArray: [Sound]
}

protocol ProjectEditorViewModel: ObservableObject {
    var state: ProjectEditorViewState { get }
    
    func handle(_ event: ProjectEditorViewEvent)
    
    func setSelectedSound(at index: String)
    
    func areUuidsSimilar(id1: String, id2: String) -> Bool
}

final class ProjectEditorViewModelImp: ProjectEditorViewModel {
    @Environment(\.router) var router: Router
    @Published var state = ProjectEditorViewState(
        indicatorViewState: .loading,
        project: nil,
        shouldShowPause: false,
        pauseState: "play.fill",
        isChervonDown: false,
        chervonDirection: "chevron.down",
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
    
    let projectProvider: ProjectProvider
    
    init(projectProvider: ProjectProvider) {
        self.projectProvider = projectProvider
    }
    
    func handle(_ event: ProjectEditorViewEvent) {
        switch event {
        case .onLoadData(projectId: let projectId):
            loadData(projectId: projectId)
        case .tapBackButton:
            saveData()
            toMainView()
            state.project = nil
        case .tapVisualizationButton:
            saveData()
            toPlayProjectView()
            state.project = nil
        case .tapAddSounds:
            saveData()
            toSoundsListView()
        case .tapButton:
            state.shouldShowPause.toggle()
            state.pauseState = (state.shouldShowPause ? "pause.fill": "play.fill")
        case .tapChervon:
            state.isChervonDown.toggle()
            state.chervonDirection = (state.isChervonDown ? "chevron.up" : "chevron.down")
        }
    }
    
    func setSelectedSound(at id: String) {
        state.choosenSoundId = id
    }
    
    func areUuidsSimilar(id1: String, id2: String) -> Bool {
        return id1 == id2
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
    
    func loadData(projectId: String?) {
        state.indicatorViewState = .loading
        
        guard state.project == nil else {
            state.indicatorViewState = .display
            return
        }
        
        guard let projectId else {
            projectProvider.create(project: .init(metronomeBpm: 100, name: UUID().uuidString)) { [weak self] project, isCompleted in
                if isCompleted {
                    self?.state.project = project
                    self?.state.indicatorViewState = .display
                } else {
                    self?.state.indicatorViewState = .error
                }
            }
            return
        }
        
        projectProvider.loadData(by: projectId) { [weak self] result in
            switch result {
            case .success(let project):
                self?.state.project = project
                self?.state.indicatorViewState = .display
            case .failure(_):
                self?.state.indicatorViewState = .error
            }
        }
    }
    
    func saveData() {
        guard let project = state.project else {
            return
        }
        
        projectProvider.saveData(project: project) { _ in
            // Обработать ошибку
        }
    }
    
    // MARK: Routing
    
    func toMainView() {
        router.path.removeLast()
    }
    
    func toPlayProjectView() {
        guard let id = state.project?.id else {
            return
        }
        
        router.path.append(Route.playProject(projectId: id))
    }
    
    func toSoundsListView() {
        guard let id = state.project?.id else {
            return
        }
        
        router.path.append(Route.soundsList(projectId: id))
    }
}
