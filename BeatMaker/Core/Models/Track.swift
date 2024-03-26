//
//  Track.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI

struct Track: Hashable {
    let id: String
    let sound: Sound?
    let points: [TrackPoint]
    var isMute: Bool = false
    
    init(id: String, sound: Sound?, points: [TrackPoint]) {
        self.id = id
        self.sound = sound
        self.points = points
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
