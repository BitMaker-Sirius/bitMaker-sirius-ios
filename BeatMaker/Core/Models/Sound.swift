//
//  Sound.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI
import Foundation

final class Sound: ObservableObject, Identifiable, Hashable {
    let id: String
    let audioFileId: String?
    @Published var name: String
    @Published var emoji: String?
    let networkUrl: String?
    var storageUrl: String?
    
    /// Свойство для управления воспроизведением
    @Published var isPlaying: Bool = false
    
    /// Используется при создании Sound, сам назначает id
    init(
        audioFileId: String?,
        name: String,
        emoji: String? = nil,
        networkUrl: String? = nil,
        storageUrl: String? = nil
    ) {
        self.id = UUID().uuidString
        self.audioFileId = audioFileId
        self.name = name
        self.emoji = emoji
        self.networkUrl = networkUrl
        self.storageUrl = storageUrl
    }
    
    /// Используется при обновлении Sound
    convenience init(
        id: String,
        sound: Sound
    ) {
        self.init(
            id: id,
            audioFileId: sound.audioFileId,
            name: sound.name,
            emoji: sound.emoji,
            networkUrl: sound.networkUrl,
            storageUrl: sound.storageUrl
        )
    }
    
    /// Используется для перевода в domain model
    init?(from soundObject: SoundObject?) {
        guard let soundObject else {
            return nil
        }
        
        self.id = soundObject.id
        self.audioFileId = soundObject.audioFileId
        self.name = soundObject.name
        self.emoji = soundObject.emoji
        self.networkUrl = soundObject.networkUrl
        self.storageUrl = soundObject.storageUrl
    }
    
    private init(
        id: String,
        audioFileId: String?,
        name: String,
        emoji: String?,
        networkUrl: String?,
        storageUrl: String?
    ) {
        self.id = id
        self.audioFileId = audioFileId
        self.name = name
        self.emoji = emoji
        self.networkUrl = networkUrl
        self.storageUrl = storageUrl
    }
    
    static func == (lhs: Sound, rhs: Sound) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
