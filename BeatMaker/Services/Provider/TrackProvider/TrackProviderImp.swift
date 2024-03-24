//
//  TrackProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class TrackProviderImp: TrackProvider {
    var track: Track
    
    init(track: Track) {
        self.track = track
    }
}
