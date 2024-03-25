//
//  PlayTrackViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class PlayProjectViewModel: PlayProjectViewModeling {
    @Published var state: PlayProjectViewState
    
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
        let isList = projectList.count > 1
        self.projectList = projectList
        currentProjectIndex = projectList.firstIndex(of: project) ?? 0
        state = .init(project: project, totalTime: 30, liked: false, formatTime: "00:00", isList: isList)
    }
    
    // MARK: Private fields
    private var timer: Timer?
    private var projectList: [Project]
    private var currentProjectIndex: Int
    
    // MARK: Private methods
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
        currentProjectIndex = (currentProjectIndex + 1) % projectList.count
        updateCurrentProject()
    }
    
    private func prevTap() {
        guard state.isList else { return }
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
        stopPlayback()
        startPlayback()
    }
    
    private func likeTap() {
        state.liked.toggle()
        // TODO: Добавить изменение модели через какой-то сервис
    }
    
    private func startPlayback() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self, state.isPlaying else { return }
            
            DispatchQueue.main.async {
                let nextSliderValue = self.state.currentTime + 1
                if nextSliderValue <= self.state.totalTime {
                    self.state.currentTime = nextSliderValue
                    self.state.formatTime = self.formatTime(nextSliderValue)
                } else {
                    self.state.currentTime = 0
                }
            }
        }
    }
    
    private func stopPlayback() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTime(_ time: Double) -> String {
        let totalSeconds = Int(time)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
