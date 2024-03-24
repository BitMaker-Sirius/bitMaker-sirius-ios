//
//  Track.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI

struct Track {
    let id: String
    let sound: Sound?
    let points: [TrackPoint]
    var isMute: Bool = false
    
    init(id: String, sound: Sound?, points: [TrackPoint]) {
        self.id = id
        self.sound = sound
        self.points = points
    }
}
