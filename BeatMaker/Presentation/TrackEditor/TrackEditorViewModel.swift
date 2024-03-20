//
//  TrackEditorViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackEditorViewModel: ObservableObject {
    @Published var selectedSounds: [Sound] = []
    
    func addOrRemoveSound(_ sound: Sound) {
        if let index = selectedSounds.firstIndex(where: { $0.name == sound.name }) {
            selectedSounds.remove(at: index)
        } else {
            selectedSounds.append(sound)
        }
    }
    
    func isSoundSelected(_ sound: Sound) -> Bool {
        return selectedSounds.contains(where: { $0.name == sound.name })
    }
    
    // Обработка действий пользователя
}
