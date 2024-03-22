//
//  Assembly+AudioServices.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

extension Assembly {
    func projectPlaybackService() -> ProjectPlaybackService {
        .init(trackPlaybackService: trackPlaybackService())
    }
    
    func trackPlaybackService() -> TrackPlaybackService {
        .init(soundPlaybackService: soundPlaybackService())
    }
    
    func soundPlaybackService() -> SoundPlaybackService {
        .init()
    }
    
    func visualizationService() -> VisualizationService {
        VisualizationServiceImp()
    }
    
    func samplingService() -> SamplingService {
        SamplingServiceImp()
    }
    
    func recordingService() -> RecordingService {
        RecordingServiceImp()
    }
}
