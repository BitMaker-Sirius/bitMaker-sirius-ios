//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import RealmSwift

final class ProjectObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var metronomeBpm: Int
    @Persisted var name: String
    @Persisted var image: String?
    @Persisted var updateDate: Date?
    @Persisted var preparedSounds: List<SoundObject>
    @Persisted var tracks: List<TrackObject>
    
    convenience init(from project: Project) {
        self.init()
        self.id = project.id
        self.metronomeBpm = project.metronomeBpm
        self.name = project.name
        self.image = project.image
        self.updateDate = project.updateDate
        preparedSounds.append(objectsIn: project.preparedSounds.compactMap { SoundObject(from: $0) })
        tracks.append(objectsIn: project.tracks.map { TrackObject(from: $0) })
    }
}
