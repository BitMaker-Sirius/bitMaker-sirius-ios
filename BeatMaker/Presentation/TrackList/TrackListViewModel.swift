//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(id: UUID().uuidString, name: "name", image: UUID().uuidString, updateDate: Date(), metronomeBpm: 1, preparedSounds: [], tracks: [])
//        Project(name: "Project 1", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: []),
//        Project(name: "Project 1", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: []),
//        Project(name: "Project 1", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: [])
    ]
    
    // Обработка действий пользователя
}
