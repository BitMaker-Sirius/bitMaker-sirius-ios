//
//  SamplingService.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import AVFoundation

protocol PlaybackService<PlayingDataType> {
    associatedtype PlayingDataType
    
    func play(_ data: PlayingDataType)
    func stop(_ data: PlayingDataType)
}
