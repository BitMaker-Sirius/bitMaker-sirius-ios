//
//  ProjectPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class ProjectPlaybackServiceImp: ProjectPlaybackService {
    let trackPlaybackService: any TrackPlaybackService
    
    init(trackPlaybackService: any TrackPlaybackService) {
        self.trackPlaybackService = trackPlaybackService
    }
    
    func play(_ data: Project) {
        // Воспроизведение проекта из массива Track'ов внутри Project с помощью ProjectPlaybackService
    }
    
    func stop(_ data: Project) {
        
    }
}
