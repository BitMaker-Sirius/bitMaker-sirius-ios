//
//  Sound.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct Sound: Identifiable, Hashable {
    let id: String
    let audioFileId: String?
    let name: String
    let emoji: String?
    
    init(
        id: String,
        audioFileId: String?,
        name: String,
        emoji: String? = nil
    ) {
        self.id = id
        self.audioFileId = audioFileId
        self.name = name
        self.emoji = emoji
    }
    
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
