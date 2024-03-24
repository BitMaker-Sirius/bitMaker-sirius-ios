//
//  TrackListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class TrackListProviderImp: TrackListProvider {
    var trackList: [Track]
    
    init(trackList: [Track]) {
        self.trackList = trackList
    }
}
