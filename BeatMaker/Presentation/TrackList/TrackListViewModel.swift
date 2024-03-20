//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var tracks: [Track] = [
        Track(name: "Трек 1", description: "Описание трека 1"),
        Track(name: "Трек 2", description: "Описание трека 2")
    ]
    
    // Обработка действий пользователя
}
