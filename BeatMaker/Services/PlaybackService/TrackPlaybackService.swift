//
//  TrackPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

final class TrackPlaybackService: PlaybackService {
    let soundPlaybackService: SoundPlaybackService
    
    init(soundPlaybackService: SoundPlaybackService) {
        self.soundPlaybackService = soundPlaybackService
    }
    
    func play(_ data: Track) {
        // Воспроизведение трека из массива TrackPoint'ов внутри Track с помощью SoundPlaybackService
    }
    
    func stop(_ data: Track) {
        
    }
}
