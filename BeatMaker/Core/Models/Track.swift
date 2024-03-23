//
//  Track.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI

final class Track: ObservableObject {
    let id: String
    let sound: Sound?
    let points: [TrackPoint]
    @Published var isMute: Bool = false
    
    init(id: String, sound: Sound?, points: [TrackPoint]) {
        self.id = id
        self.sound = sound
        self.points = points
    }
}
