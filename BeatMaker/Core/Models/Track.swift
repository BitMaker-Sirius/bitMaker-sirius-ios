//
//  Track.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import SwiftUI
import Foundation

final class Track: ObservableObject, Hashable {
    let id: String
    let sound: Sound?
    @Published var points: [TrackPoint]
    @Published var isMute: Bool
    
    /// Используется при обновлении Track
    init(
        sound: Sound?,
        points: [TrackPoint],
        isMute: Bool = false
    ) {
        self.id = UUID().uuidString
        self.sound = sound
        self.points = points
        self.isMute = isMute
    }
    
    /// Используется для перевода в domain model
    init(from trackObject: TrackObject) {
        self.id = trackObject.id
        self.sound = Sound(from: trackObject.sound)
        self.points = trackObject.points.map { TrackPoint(from: $0) }
        self.isMute = trackObject.isMute
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
