//
//  Track.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 22.03.2024.
//

import RealmSwift

final class TrackObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var sound: SoundObject?
    @Persisted var points: List<TrackPointObject>
    @Persisted var isMute: Bool
    
    convenience init(from track: Track) {
        self.init()
        self.id = track.id
        self.sound = SoundObject(from: track.sound)
        points.append(objectsIn: track.points.map { TrackPointObject(from: $0) })
        self.isMute = track.isMute
    }
}
