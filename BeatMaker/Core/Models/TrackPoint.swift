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
    
    init(from trackPointObject: TrackPointObject) {
        self.startTime = trackPointObject.startTime
        self.volume = trackPointObject.volume
        self.pitch = trackPointObject.pitch
    }
}
