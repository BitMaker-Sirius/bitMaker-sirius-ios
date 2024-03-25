//
//  TrackPoint.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import Foundation
import RealmSwift

final class TrackPointObject: Object {
    @Persisted var startTime: TimeInterval
    @Persisted var volume: Double?
    @Persisted var pitch: Double?
    
    convenience init(from trackPoint: TrackPoint) {
        self.init()
        self.startTime = trackPoint.startTime
        self.volume = trackPoint.volume
        self.pitch = trackPoint.pitch
    }
}
