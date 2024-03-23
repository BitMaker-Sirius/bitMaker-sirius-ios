//
//  TrackListProviderImp.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 23.03.2024.
//

import SwiftUI

final class TrackListProviderImp: TrackListProvider {
    var trackList: State<[Track]>
    
    init(trackList: [Track]) {
        self.trackList = State(wrappedValue: trackList)
    }
}
