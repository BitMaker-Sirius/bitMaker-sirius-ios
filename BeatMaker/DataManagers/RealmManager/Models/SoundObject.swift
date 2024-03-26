//
//  Sound.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import RealmSwift

final class SoundObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var audioFileId: String?
    @Persisted var name: String
    @Persisted var emoji: String?
    
    convenience init?(from sound: Sound?) {
        self.init()
        
        guard let sound else {
            return nil
        }
        
        self.id = sound.id
        self.audioFileId = sound.audioFileId
        self.name = sound.name
        self.emoji = sound.emoji
    }
}
