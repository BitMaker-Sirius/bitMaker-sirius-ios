//
//  SoundListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class SoundListViewModel: ObservableObject {
    @Published var sounds: [Sound]
    
    init() {
        sounds = FIleManagerService.shared.getSounds()
    }
}
