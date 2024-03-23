//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(id: "1", metronomeBpm: 1),
        Project(id: "1", metronomeBpm: 1),
        Project(id: "1", metronomeBpm: 1),
    ]
    
    // Обработка действий пользователя
}
