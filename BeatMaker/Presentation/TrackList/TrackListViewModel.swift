//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(id: "1", metronomeBpm: 1, name: "Project 1"),
        Project(id: "2", metronomeBpm: 1, name: "Project 2"),
        Project(id: "3", metronomeBpm: 1, name: "Project 3"),
    ]
    
    // Обработка действий пользователя
}
