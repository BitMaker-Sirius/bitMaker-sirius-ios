//
//  TrackListViewModel.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation

class TrackListViewModel: ObservableObject {
    @Published var projects: [Project] = [
        Project(metronomeBpm: 1, name: "1"),
        Project(metronomeBpm: 1, name: "2"),
        Project(metronomeBpm: 1, name: "3"),
    ]
}
