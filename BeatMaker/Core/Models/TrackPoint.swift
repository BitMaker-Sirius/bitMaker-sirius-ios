//
//  TrackPoint.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation

struct TrackPoint {
    let startTime: TimeInterval
    let volume: Double?
    let pitch: Double?
    
    init(
        startTime: TimeInterval,
        volume: Double?,
        pitch: Double?
    ) {
        self.startTime = startTime
        self.volume = volume
        self.pitch = pitch
    }
    
    init(from trackPointObject: TrackPointObject) {
        self.startTime = trackPointObject.startTime
        self.volume = trackPointObject.volume
        self.pitch = trackPointObject.pitch
    }
}
