//
//  Track.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct Track: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
}
