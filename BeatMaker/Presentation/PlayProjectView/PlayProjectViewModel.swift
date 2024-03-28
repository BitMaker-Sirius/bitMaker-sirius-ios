//
//  PlayTrackViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

enum PlayProjectViewEvent {
    case onLoadData(projectId: String)
    case playTap
    case nextTap
    case prevTap
    case editTap
    case backTap
}

struct PlayProjectViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var project: Project?
    var projectsList: [Project]
    
    var isPlaying: Bool = false
    var currentTime: Double = 0
    var totalTime: Double = 100
    var liked: Bool = false
    var formatTime: String = "00:00"
    var isList: Bool = false
}

protocol PlayProjectViewModel: ObservableObject {
    var state: PlayProjectViewState { get }

    func handle(_ event: PlayProjectViewEvent)
}

class PlayProjectViewModelImp: PlayProjectViewModel {
    @Environment(\.router) var router: Router
    @Published var state: PlayProjectViewState = .init(
        indicatorViewState: .loading,
        project: .init(metronomeBpm: 0, name: "name"),
        projectsList: []
    )
    
    let audioProcessing = SpeechVizualizationViewModelImp.shared
    let projectProvider: ProjectProvider
    let projectsListProvider: ProjectsListProvider
    let projectPlaybackService: any ProjectPlaybackService
    
    init(
        projectProvider: ProjectProvider,
        projectsListProvider: ProjectsListProvider,
        projectPlaybackService: any ProjectPlaybackService
    ) {
        self.projectProvider = projectProvider
        self.projectsListProvider = projectsListProvider
        self.projectPlaybackService = projectPlaybackService
    }
    
    func handle(_ event: PlayProjectViewEvent) {
        switch event {
        case .onLoadData(let projectId):
            loadData(projectId: projectId)
        case .playTap:
            playTap()
        case .nextTap:
            nextTap()
        case .prevTap:
            prevTap()
        case .editTap:
            stopPlayback()
            toProjectEditor()
        case .backTap:
            stopPlayback()
            toMainView()
        }
    }
    
    // MARK: Private fields
    private var playbackTimer: Timer? = nil
    private var currentProjectIndex: Int = 0
    
    // MARK: Settings fields
    private let timerPlus = 0.2
    
    // MARK: Private methods
    private func countTotalTime() {
        guard let metronomeBpm = state.project?.metronomeBpm else {
            return
        }
        
        let totalBars = 20
        state.totalTime = TimeInterval(totalBars) * 60 / TimeInterval(metronomeBpm)
    }
    
    private func playTap() {
        state.isPlaying.toggle()
        // TODO: Добавить остановку/запуск музыки через какой-то сервис
        if state.isPlaying {
            startPlayback()
        } else {
            stopPlayback()
        }
    }
    
    private func nextTap() {
        guard state.isList else { return }
        stopPlayback()
        currentProjectIndex = (currentProjectIndex + 1) % state.projectsList.count
        updateCurrentProject()
    }
    
    private func prevTap() {
        guard state.isList, let project = state.project else { return }
        stopPlayback()
        projectPlaybackService.stop(project)
        currentProjectIndex = (currentProjectIndex - 1 + state.projectsList.count) % state.projectsList.count
        updateCurrentProject()
    }
    
    private func editTap() {
        
    }
    
    private func updateCurrentProject() {
        let newProject = state.projectsList[currentProjectIndex]
        state.project = newProject
        state.currentTime = 0
        state.formatTime = formatTime(0)
        state.isPlaying = true
        countTotalTime()
        startPlayback()
    }
    
    private func likeTap() {
        state.liked.toggle()
        // TODO: Добавить изменение модели через какой-то сервис
    }
    
    private func startPlayback() {
        guard let project = state.project else { return }
        projectPlaybackService.play(project)
        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(timeInterval: timerPlus, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
        audioProcessing.startMusic() //!
    }
    
    @objc private func updateCurrentTime() {
        guard let project = state.project else { return }
        
        if state.currentTime < state.totalTime {
            state.currentTime += timerPlus
            state.formatTime = formatTime(state.currentTime)
        } else {
            projectPlaybackService.stop(project)
            projectPlaybackService.play(project)
            state.currentTime = 0
            state.formatTime = formatTime(state.currentTime)
        }
    }
    
    private func stopPlayback() {
        guard let project = state.project else { return }
        projectPlaybackService.stop(project)
        playbackTimer?.invalidate()
        playbackTimer = nil
        state.currentTime = 0
        state.formatTime = formatTime(state.currentTime)
        audioProcessing.stopMusic() //!
    }
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func loadData(projectId: String) {
        self.state = .init(indicatorViewState: .loading, projectsList: [])
        
        projectProvider.loadData(by: projectId) { [weak self] result in
            switch result {
            case .success(let project):
                self?.state.project = project
                self?.countTotalTime()
                
                self?.projectsListProvider.loadData { result in
                    switch result {
                    case .success(let projectsList):
                        self?.state.projectsList = projectsList
                        self?.state.isList = self?.state.projectsList.count ?? 0 > 1
                        self?.currentProjectIndex = projectsList.firstIndex(where: { $0.id == projectId }) ?? 0
                        self?.state.indicatorViewState = .display
                    case .failure(_):
                        self?.state.indicatorViewState = .error
                    }
                }
            case .failure(_):
                self?.state.indicatorViewState = .error
            }
        }
    }
    
    // MARK: Routing
    
    private func toMainView() {
        while router.path.count != 0 {
          router.path.removeLast()
        }
    }
    
    private func toProjectEditor() {
        guard let projectId = state.project?.id else {
            return
        }
        
        router.path.append(Route.projectEditor(projectId: projectId))
    }
}
