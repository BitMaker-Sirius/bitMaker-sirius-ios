//
//  TrackEditorViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

enum ProjectEditorViewEvent {
    case tapBackButton
    case tapVisualizationButton
    case tapAddSounds
    case tapButton
    case tapChervon
}

struct ProjectEditorViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var project: Project
    
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
    
    @Published
    var state = ProjectEditorViewState(
        indicatorViewState: .display,
        project: Project(metronomeBpm: 100, name: "name"),
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
    
    func handle(_ event: ProjectEditorViewEvent) {
        switch event {
        case .tapBackButton:
            toMainView()
        case .tapVisualizationButton:
            toPlayProjectView()
        case .tapAddSounds:
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
    
    // MARK: Routing
    
    func toMainView() {
        router.path.removeLast()
    }
    
    func toPlayProjectView() {
        router.path.append(Route.playProject(projectId: state.project.id))
    }
    
    func toSoundsListView() {
        router.path.append(Route.soundsList(projectId: state.project.id))
    }
}
