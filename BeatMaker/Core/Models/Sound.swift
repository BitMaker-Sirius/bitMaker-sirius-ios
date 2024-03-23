//
//  Sound.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

final class Sound: ObservableObject, Identifiable {
    let id: String
    let audioFileId: String?
    @Published var name: String?
    @Published var emoji: String?
    
    init(
        id: String,
        audioFileId: String?,
        name: String? = nil,
        emoji: String? = nil
    ) {
        self.id = id
        self.audioFileId = audioFileId
        self.name = name
        self.emoji = emoji
    }
}
