//
//  SoundPlaybackService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 24.03.2024.
//

import Foundation

//protocol SoundPlaybackService: PlaybackService where PlayingDataType == Sound {}

protocol SoundPlaybackService: AnyObject {
    func playSound(url: URL, atTime time: TimeInterval, volume: Float, pitch: Float)

    func stopAllSounds()
}
