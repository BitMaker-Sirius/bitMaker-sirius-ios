//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

struct Project: Identifiable, Hashable {
    let id: String
    let name: String?
    let image: String?
    let updateDate: Date?
    let metronomeBpm: Int
    let preparedSounds: [Sound]
    let tracks: [Track]
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
