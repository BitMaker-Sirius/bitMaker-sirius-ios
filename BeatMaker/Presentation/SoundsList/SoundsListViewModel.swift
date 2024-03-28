//
//  SoundListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI
import AVFoundation

enum SoundsListViewEvent {
    case onLoadData(projectId: String)
    
    case tapBackButton
    case tapOnCellPlayButton(url: String)
    case tapOnCellDownloadButton(sound: Sound)
    case tapOnCell(sound: Sound)
}

struct SoundsListViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var project: Project?
    var soundsList: [Sound]
    var allAvailableSounds: [Sound]
    var isAlertPresented: Bool
    var nameInAlert: String
}

protocol SoundsListViewModel: ObservableObject {
    var state: SoundsListViewState { get set }
    func handle(_ event: SoundsListViewEvent)
}

class SoundsListViewModelImp: SoundsListViewModel {
    @Environment(\.router) var router: Router
    @Published var state = SoundsListViewState(
        indicatorViewState: .display,
        project: nil,
        soundsList: [], 
        allAvailableSounds: [],
        isAlertPresented: false,
        nameInAlert: ""
    )
    
    let projectProvider: ProjectProvider
    private let soundsListProvider: SoundsListProvider
    
    private let soundPlaybackService: SoundPlaybackService
    private let fileManager: FileManagerProtocol
    
    init(projectProvider: ProjectProvider,
         soundsListProvider: SoundsListProvider,
         soundPlaybackService: SoundPlaybackService,
         fileManager: FileManagerProtocol) {
        
        self.projectProvider = projectProvider
        self.soundsListProvider = soundsListProvider
        self.soundPlaybackService = soundPlaybackService
        self.fileManager = fileManager
        
        soundsListProvider.loadData { [weak self] result in
            guard let self else {
                return
            }
            switch result{
            case .success(let soundArray):
                for storedSound in soundArray {
                    for (key, value) in fileManager.getAvailableFirebaseSoundsList() {
                        if storedSound.name == key {
                            state.allAvailableSounds.append(storedSound)
                        }
                    }
                }
            case .failure(_):
                for (key, value) in fileManager.getAvailableFirebaseSoundsList() {
                    let emoji = String(UnicodeScalar(Array(0x1F601...0x1F64F).randomElement()!)!)
                    let id = UUID().uuidString
                    state.allAvailableSounds.append(Sound(audioFileId: id, name: key, emoji: emoji, networkUrl: value, storageUrl: nil))
                }
            }
        }
        
        for (key, value) in fileManager.getAvailableFirebaseSoundsList() {
            if !state.allAvailableSounds.contains(where: { $0.name == key }) {
                let emoji = String(UnicodeScalar(Array(0x1F601...0x1F64F).randomElement()!)!)
                let id = UUID().uuidString
                let newSound = Sound(audioFileId: id, name: key, emoji: emoji, networkUrl: value, storageUrl: nil)
                state.allAvailableSounds.append(newSound)
                soundsListProvider.add(sound: newSound) { isCompleted in
                    
                }
            }
        }

        
        state.allAvailableSounds.sort(by: { $0.id > $1.id })
    }
    
    func handle(_ event: SoundsListViewEvent) {
        switch event {
        case .onLoadData(let projectId):
            loadData(projectId: projectId)
        case .tapBackButton:
            saveData() { [weak self] in
                self?.toProjectEditorView()
            }
        case .tapOnCellPlayButton(let url):
            tapOnCellPlayButton(url: url)
        case .tapOnCell(let sound):
            tapOnCell(sound: sound)
        case .tapOnCellDownloadButton(let sound):
            tapOnCellDownloadButton(sound: sound)
        }
    }
    
    private func tapOnCellPlayButton(url: String) {
        
        if let urlFromString = URL(string: url) {
            soundPlaybackService.playSound(url: urlFromString, atTime: TimeInterval(), volume: 0.25, pitch: 0)
        }
    }
    
    private func tapOnCellDownloadButton(sound: Sound) {
        
        guard let url = sound.networkUrl, let urlFromString = URL(string: url) else {
            return
        }
        
        fileManager.getAVAudioFile(withID: sound.id, fromUrl: urlFromString) { [weak self] _ in
            guard let self else {
                return
            }
            
            let localUrl = fileManager.getAudioURl(withId: sound.id)
            state.allAvailableSounds[state.allAvailableSounds.firstIndex(where: { $0.id == sound.id})!].storageUrl = localUrl.absoluteString
            objectWillChange.send()
            print(localUrl.absoluteString)
        }
    }
    
    private func tapOnCell(sound: Sound) {
        objectWillChange.send()
        if state.project?.preparedSounds.contains(where: { $0.id == sound.id}) == true {
            state.project?.preparedSounds.removeAll { $0.id == sound.id }
        } else {
            state.project?.preparedSounds.append(sound)
        }
    }
    
    private func loadData(projectId: String) {
        state.indicatorViewState = .loading
        
        projectProvider.loadData(by: projectId) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let project):
                state.project = project
                
                soundsListProvider.loadData { result in
                    switch result {
                    case .success(let soundsList):
                        self.state.soundsList = soundsList
                        self.state.indicatorViewState = .display
                    case .failure(_):
                        self.state.indicatorViewState = .error
                    }
                }
            case .failure(_):
                state.indicatorViewState = .error
            }
        }
    }
    
    private func saveData(transition: @escaping (() -> Void)) {
        guard let project = state.project else {
            return
        }
        
        state.indicatorViewState = .loading
        
        for someSound in state.allAvailableSounds {
            soundsListProvider.add(sound: someSound) { isCompleted in
                
            }
        }
        
        projectProvider.saveData(project: project) { isCompleted in
            transition()
        }
    }
    
    // MARK: Routing
    
    private func toProjectEditorView() {
        router.path.removeLast()
    }
}
