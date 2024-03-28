//
//  ProjectPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectPlaybackServiceImp: ProjectPlaybackService {
    private let trackPlaybackService: any TrackPlaybackService
    
    init(trackPlaybackService: any TrackPlaybackService) {
        self.trackPlaybackService = trackPlaybackService
    }
    
    func play(_ data: Project) {
        data.tracks.forEach { track in
            trackPlaybackService.play(track)///
            ///if tracks.isSpeech == true {
            ///audioProcessing.startMusic() - здесь по сути надо
            ///}
        }
    }
    
    func stop(_ data: Project) {
        data.tracks.forEach { track in
            trackPlaybackService.stop(track)///
            ///if tracks.isSpeech == true {
            ///audioProcessing.stopMusic() - здесь по сути надо
            ///}
        }
    }
}
