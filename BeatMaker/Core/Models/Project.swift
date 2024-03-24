//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct Project: Identifiable, Hashable {
    let id: String
    let metronomeBpm: Int
    var name: String
    var image: String?
    var updateDate: Date?
    var preparedSounds: [Sound]
    var tracks: [Track]
    
    init(
        id: String, 
        metronomeBpm: Int, 
        name: String,
        image: String? = nil,
        updateDate: Date? = nil,
        preparedSounds: [Sound] = [],
        tracks: [Track] = []
    ) {
        self.id = id
        self.metronomeBpm = metronomeBpm
        self.name = name
        self.image = image
        self.updateDate = updateDate
        self.preparedSounds = preparedSounds
        self.tracks = tracks
    }

    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
