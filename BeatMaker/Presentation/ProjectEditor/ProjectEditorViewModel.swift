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
    case onChangeName(projectName: String)
    case onCheckName
    
    case tapBackButton
    case tapVisualizationButton
    case tapAddSounds
    case tapPlay
    case tapChervon
    case recordTap
}

struct ProjectEditorViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var project: Project?
    var isNeedProjectRenameAlert: Bool
    
    var currentTime: Double = 0
    var totalTime: Double = 100
    var isPlaying: Bool
    var isRecording: Bool = false
    var selectedSound: Sound?
    var trackPointList: [TrackPoint] = []
    var trackList: [Track] = []
    var pauseState: String
    var isChervonDown: Bool
    var chervonDirection: String
    var choosenSoundId: String?
    var soundsArray: [Sound]
    var usedTrackViewModel: UsedTrackViewModel
}

protocol ProjectEditorViewModel: ObservableObject {
    var state: ProjectEditorViewState { get }
    
    func handle(_ event: ProjectEditorViewEvent)
    
    func setSelectedSound(at index: String)
    
    func areUuidsSimilar(id1: String, id2: String) -> Bool
    
    func handleCoordinateChange(_ point: CGPoint)
}

final class ProjectEditorViewModelImp: ProjectEditorViewModel {
    @Environment(\.router) var router: Router
    @Published var state = ProjectEditorViewState(
        indicatorViewState: .loading,
        project: nil,
        isNeedProjectRenameAlert: false,
        isPlaying: false,
        pauseState: "play.fill",
        isChervonDown: false,
        chervonDirection: "chevron.down",
        choosenSoundId: nil,
        soundsArray: [
//            Sound(audioFileId: "long-sound-on-sms-11-seconds-about-china", name: "china", emoji: "\u{1F1E8}\u{1F1F3}"),
//            Sound(audioFileId: "iphone-sms", name: "iphone-sms", emoji: "\u{1F4F1}"),
//            Sound(audioFileId: "sms-for-samsung", name: "sms-for-samsung", emoji: "\u{1F4F1}"),
//            Sound(audioFileId: "alarm-ringing-for-sms", name: "alarm-ringing-for-sms", emoji: "\u{23F0}"),
//            Sound(audioFileId: "s6-edge-sms", name: "s6-edge-sms", emoji: "\u{1F4E7}"),
//            Sound(audioFileId: "s6-edge-sms", name: "s6-edge-sms", emoji: "\u{1F4E7}"),
//            Sound(audioFileId: "s6-edge-sms", name: "s6-edge-sms", emoji: "\u{1F4E7}"),
        ],
        usedTrackViewModel: UsedTrackViewModel()
    )
    
    let projectProvider: ProjectProvider
    
    private let timerPlus = 0.1
    private var playbackTimer: Timer? = nil
    let soundPlaybackService: SoundPlaybackService
    let trackPlaybackService: any TrackPlaybackService
    let projectPlaybackService: any ProjectPlaybackService
    let fileManager: FileManagerProtocol

    init(projectProvider: ProjectProvider, fileManager: FileManagerProtocol) {
        soundPlaybackService = SoundPlaybackServiceImp()
        trackPlaybackService = TrackPlaybackServiceImp(soundPlaybackService: soundPlaybackService)
        projectPlaybackService = ProjectPlaybackServiceImp(trackPlaybackService: trackPlaybackService)
        self.projectProvider = projectProvider
        self.fileManager = fileManager
        countTotalTime()
        if let array = state.project?.preparedSounds {
            selectedSounds = array
        }
    }
    
    func handle(_ event: ProjectEditorViewEvent) {
        switch event {
        case .onLoadData(projectId: let projectId):
            loadData(projectId: projectId)
        case .onChangeName(projectName: let projectName):
            changeName(projectName: projectName)
        case .onCheckName:
            checkName()
        case .tapBackButton:
            if state.project?.name == "" {
                state.isNeedProjectRenameAlert = true
                return
            }
            
            stopProcess()
            saveData() { [weak self] _ in
                self?.toMainView()
            }
        case .tapVisualizationButton:
            if state.project?.name == "" {
                state.isNeedProjectRenameAlert = true
                return
            }
            
            stopProcess()
            saveData() { [weak self] projectId in
                self?.toPlayProjectView(projectId: projectId)
            }
        case .tapAddSounds:
            stopProcess()
            saveData() { [weak self] projectId in
                self?.toSoundsListView(projectId: projectId)
            }
        case .tapPlay:
            playTap()
        case .tapChervon:
            openTrackListTap()
        case .recordTap:
            recordTap()
        }
    }
    
    func setSelectedSound(at id: String) {
        if state.isRecording {
            addNewTrackIfNeeded()
        }
        state.choosenSoundId = id
        state.selectedSound = state.project?.preparedSounds.first { $0.id == id }
//        state.selectedSound = state.soundsArray.first { $0.id == id }
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
            guard let id = state.project?.id else {
                return
            }
            
            projectProvider.loadData(by: id) { [weak self] result in
                switch result {
                case .success(let project):
                    self?.state.project = project
                    self?.countTotalTime()
                    self?.state.indicatorViewState = .display
                case .failure(_):
                    self?.state.indicatorViewState = .error
                }
            }
            return
        }
        
        guard let projectId else {
            let imageId = UUID().uuidString
            fileManager.getUIImage(withID: imageId) { result in
                switch result {
                case .success(let a):
                    print(a)
                case .failure(_):
                    return
                }
            }
            state.project = .init(metronomeBpm: 130, name: "", image: imageId)
            countTotalTime()
            state.indicatorViewState = .display
            
            return
        }
        
        projectProvider.loadData(by: projectId) { [weak self] result in
            switch result {
            case .success(let project):
                self?.state.project = project
                self?.countTotalTime()
                self?.state.indicatorViewState = .display
            case .failure(_):
                self?.state.indicatorViewState = .error
            }
        }
    }
    
    func saveData(transition: @escaping ((_ projectId: String) -> Void)) {
        guard let project = state.project else {
            return
        }
        
        state.indicatorViewState = .loading
        
        projectProvider.saveData(project: project) { [weak self] _ in
            let projectId = self?.state.project?.id
            
            if let projectId {
                transition(projectId)
            }
        }
    }
    
    func changeName(projectName: String) {
        state.project?.name = projectName
    }
    
    func checkName() {
        if state.project?.name != "" {
            state.isNeedProjectRenameAlert = false
        }
    }
    
    private func stopProcess() {
        if state.isPlaying {
            playTap()
        }
        
        if state.isRecording {
            recordTap()
        }
        
        state.isChervonDown = false
        state.chervonDirection = "chevron.down"
        
        soundPlaybackService.stopAllSounds()
        
        state.choosenSoundId = nil
        state.selectedSound = nil
    }
    
    private func countTotalTime() {
        let totalBars = 20
        state.totalTime = TimeInterval(totalBars) * 60 / TimeInterval(state.project?.metronomeBpm ?? 120)
    }
    
    private func playTap() {
        state.isPlaying.toggle()
        state.pauseState = (state.isPlaying ? "stop.fill": "play.fill")
        
        if state.isPlaying {
            startPlayback()
        } else {
            stopPlayback()
        }
    }
    
    private func openTrackListTap() {
        if state.isChervonDown {
            state.project?.tracks = state.usedTrackViewModel.state.usedTacksArray
        } else {
            if state.isRecording {
                recordTap()
            }
            if state.isPlaying {
                playTap()
            }
            state.usedTrackViewModel.updateTracks(state.project?.tracks ?? [])
        }
        state.isChervonDown.toggle()
        state.chervonDirection = (state.isChervonDown ? "chevron.up" : "chevron.down")
    }
    
    private func startPlayback() {
        guard let project = state.project else {
            return
        }
        projectPlaybackService.play(project)
        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(timeInterval: timerPlus, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCurrentTime() {
        guard let project = state.project else {
            return
        }
        if state.currentTime < state.totalTime {
            state.currentTime += timerPlus
        } else {
            projectPlaybackService.stop(project)
            projectPlaybackService.play(project)
            state.currentTime = 0
        }
    }
    
    private func addNewTrackIfNeeded() {
        if !state.trackPointList.isEmpty {
            let track = Track(sound: state.selectedSound, points: state.trackPointList)
            state.project?.tracks.append(track)
        }
        state.trackPointList = []
    }
    
    private func stopPlayback() {
        guard let project = state.project else {
            return
        }
        projectPlaybackService.stop(project)
        playbackTimer?.invalidate()
        playbackTimer = nil
        state.currentTime = 0
    }
    
    func handleCoordinateChange(_ point: CGPoint) {
        guard let sound = state.selectedSound, let storageUrl = sound.storageUrl, let soundUrl = URL(string: storageUrl) else {
            return
        }
        let volume = Double(point.y)
        let pitch = Double(point.x)
        soundPlaybackService.playSound(url: soundUrl, atTime: 0, volume: Float(volume), pitch: Float(pitch))
        
        if state.isRecording {
            state.trackPointList.append(.init(startTime: state.currentTime, volume: volume, pitch: pitch))
        }
        
        print(state.currentTime, point.y, point.x)
    }
    
    func updateTracks() {
        state.usedTrackViewModel.updateTracks([])
    }
    
    private func recordTap() {
        state.isRecording.toggle()
        if !state.isPlaying {
            playTap()
        }
        if !state.isRecording {
            addNewTrackIfNeeded()
            stopPlayback()
            startPlayback()
            state.isPlaying = true
        }
    }
    
    // MARK: Routing
    
    func toMainView() {
        state.project = nil
        
        while router.path.count != 0 {
            router.path.removeLast()
        }
    }
    
    func toPlayProjectView(projectId: String) {
        state.project = nil
        
        router.path.append(Route.playProject(projectId: projectId))
    }
    
    func toSoundsListView(projectId: String) {
        router.path.append(Route.soundsList(projectId: projectId))
    }
}
