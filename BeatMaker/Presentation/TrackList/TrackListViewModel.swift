//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(name: "Project 1", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: []),
        Project(name: "Project 2", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: []),
        Project(name: "Project 3", image: nil, upateDate: nil, bpm: 120, sounds: [], tracks: [])
    ]
    
    // Обработка действий пользователя
}
