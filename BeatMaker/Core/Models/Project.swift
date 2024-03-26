//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import Foundation
import SwiftUI

final class Project: ObservableObject, Identifiable, Hashable {
    let id: String
    let metronomeBpm: Int
    @Published var name: String
    @Published var image: String?
    @Published var updateDate: Date?
    @Published var preparedSounds: [Sound]
    @Published var tracks: [Track]
    
    /// Свойство для управления воспроизведением
    @Published var isPlaying: Bool = false
    
    /// Используется при создании Project, сам назначает id
    init(
        metronomeBpm: Int,
        name: String,
        image: String? = nil,
        updateDate: Date? = nil,
        preparedSounds: [Sound] = [],
        tracks: [Track] = []
    ) {
        self.id = UUID().uuidString
        self.metronomeBpm = metronomeBpm
        self.name = name
        self.image = image
        self.updateDate = updateDate
        self.preparedSounds = preparedSounds
        self.tracks = tracks
    }
    
    /// Используется при обновлении Project
    convenience init(
        id: String,
        project: Project
    ) {
        self.init(
            id: id,
            metronomeBpm: project.metronomeBpm,
            name: project.name,
            image: project.image,
            updateDate: project.updateDate,
            preparedSounds: project.preparedSounds,
            tracks: project.tracks
        )
    }
    
    /// Используется для перевода в domain model
    init(from projectObject: ProjectObject) {
        self.id = projectObject.id
        self.metronomeBpm = projectObject.metronomeBpm
        self.name = projectObject.name
        self.image = projectObject.image
        self.updateDate = projectObject.updateDate
        self.preparedSounds = projectObject.preparedSounds.compactMap { Sound(from: $0) }
        self.tracks = projectObject.tracks.map { Track(from: $0) }
    }
    
    private init(
        id: String,
        metronomeBpm: Int,
        name: String,
        image: String?,
        updateDate: Date?,
        preparedSounds: [Sound],
        tracks: [Track]
    ) {
        self.id = id
        self.metronomeBpm = metronomeBpm
        self.name = name
        self.image = image
        self.updateDate = updateDate
        self.preparedSounds = preparedSounds
        self.tracks = tracks
    }

    static func == (lhs: Project, rhs: Project) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
