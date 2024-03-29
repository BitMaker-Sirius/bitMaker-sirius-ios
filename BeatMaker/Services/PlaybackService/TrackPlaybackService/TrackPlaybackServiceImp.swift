//
//  TrackPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

final class TrackPlaybackServiceImp: TrackPlaybackService {
    private let soundPlaybackService: SoundPlaybackService
    
    let audioProcessing = SpeechVizualizationViewModelImp.shared
    
    init(soundPlaybackService: SoundPlaybackService) {
        self.soundPlaybackService = soundPlaybackService
    }
    
    func play(_ data: Track) {
        guard let sound = data.sound, let storageUrl = sound.storageUrl, let soundUrl = URL(string: storageUrl), !data.isMute else { return }
        
        data.points.forEach { point in
            let volume = Float(point.volume ?? 1.0)
            let pitch = Float(point.pitch ?? 0.0)
            soundPlaybackService.playSound(url: soundUrl, atTime: point.startTime, volume: volume, pitch: pitch)
//            audioProcessing.startMusic()
            
        }
    }
    
    func stop(_ data: Track) {
        soundPlaybackService.stopAllSounds()
    }
}
