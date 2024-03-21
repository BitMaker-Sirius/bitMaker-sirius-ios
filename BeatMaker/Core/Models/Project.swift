//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct Project: Identifiable {
    let id = UUID()
    let name: String
    let image: URL?
    let upateDate: Date?
    let bpm: Int
    let sounds: [Sound]
    let tracks: [Track]
}
