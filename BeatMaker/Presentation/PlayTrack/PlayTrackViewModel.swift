//
//  PlayTrackViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import Combine

class PlayProjectViewModel: PlayProjectViewModeling {
    @Published var state: PlayProjectViewState
    let soundPlaybackService: SoundPlaybackServiceImp
    let trackPlaybackService: TrackPlaybackServiceImp
    let projectPlaybackService: ProjectPlaybackServiceImp
    
    func handle(_ event: PlayProjectViewEvent) {
        switch event {
        case .playTap:
            playTap()
        case .nextTap:
            nextTap()
        case .prevTap:
            prevTap()
        case .editTap:
            editTap()
        case .likeTap:
            likeTap()
        }
    }
    
    // MARK: Init
    init(project: Project, projectList: [Project] = []) {
        soundPlaybackService = SoundPlaybackServiceImp()
        trackPlaybackService = TrackPlaybackServiceImp(soundPlaybackService: soundPlaybackService)
        projectPlaybackService = ProjectPlaybackServiceImp(trackPlaybackService: trackPlaybackService)
        
        let isList = projectList.count > 1
        self.projectList = projectList
        currentProjectIndex = projectList.firstIndex(of: project) ?? 0
        state = .init(project: project, totalTime: 30, liked: false, formatTime: "00:00", isList: isList)
        countTotalTime()
    }
    
    // MARK: Private fields
    private var playbackTimer: Timer?
    private var projectList: [Project]
    private var currentProjectIndex: Int
    
    // MARK: Settings fields
    private let timerPlus = 0.2
    
    // MARK: Private methods
    private func countTotalTime() {
        let totalBars = 20
        state.totalTime = TimeInterval(totalBars) * 60 / TimeInterval(state.project.metronomeBpm)
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
        currentProjectIndex = (currentProjectIndex + 1) % projectList.count
        updateCurrentProject()
    }
    
    private func prevTap() {
        guard state.isList else { return }
        stopPlayback()
        projectPlaybackService.stop(state.project)
        currentProjectIndex = (currentProjectIndex - 1 + projectList.count) % projectList.count
        updateCurrentProject()
    }
    
    private func editTap() {
        
    }
    
    private func updateCurrentProject() {
        let newProject = projectList[currentProjectIndex]
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
        projectPlaybackService.play(state.project)
        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(timeInterval: timerPlus, target: self, selector: #selector(updateCurrentTime), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCurrentTime() {
        if state.currentTime < state.totalTime {
            state.currentTime += timerPlus
            state.formatTime = formatTime(state.currentTime)
        } else {
            projectPlaybackService.stop(state.project)
            projectPlaybackService.play(state.project)
            state.currentTime = 0
            state.formatTime = formatTime(state.currentTime)
        }
    }
    
    private func stopPlayback() {
        projectPlaybackService.stop(state.project)
        playbackTimer?.invalidate()
        playbackTimer = nil
        state.currentTime = 0
        state.formatTime = formatTime(state.currentTime)
    }
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
