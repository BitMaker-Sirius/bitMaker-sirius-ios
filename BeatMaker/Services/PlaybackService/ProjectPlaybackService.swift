//
//  ProjectPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectPlaybackService: PlaybackService {
    init(trackPlaybackService: TrackPlaybackService) {
        self.trackPlaybackService = trackPlaybackService
    }
    
    let trackPlaybackService: TrackPlaybackService
    
    func play(_ data: Project) {
        // Воспроизведение проекта из массива Track'ов внутри Project с помощью ProjectPlaybackService
    }
    
    func stop(_ data: Project) {
        
    }
}
