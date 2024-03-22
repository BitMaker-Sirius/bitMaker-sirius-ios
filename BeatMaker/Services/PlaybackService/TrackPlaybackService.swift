//
//  TrackPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class TrackPlaybackService: PlaybackService {
    init(soundPlaybackService: SoundPlaybackService) {
        self.soundPlaybackService = soundPlaybackService
    }
    
    let soundPlaybackService: SoundPlaybackService
    
    func play(_ data: Track) {
        // Воспроизведение трека из массива TrackPoint'ов внутри Track с помощью SoundPlaybackService
    }
    
    func stop(_ data: Track) {
        
    }
}
