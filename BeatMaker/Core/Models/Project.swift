//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

final class Project: ObservableObject, Identifiable, Hashable {
    let id: String
    let metronomeBpm: Int
    @Published var name: String?
    @Published var image: String?
    @Published var updateDate: Date?
    @Published var preparedSounds: [Sound]
    @Published var tracks: [Track]
    
    init(
        id: String, 
        metronomeBpm: Int, 
        name: String? = nil,
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
