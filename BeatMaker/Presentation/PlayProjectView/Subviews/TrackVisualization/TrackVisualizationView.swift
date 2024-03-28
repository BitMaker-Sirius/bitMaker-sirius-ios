//
//  TrackVisualizationView.swift
//  BeatMaker
//
//  Created by Ирина Печик on 27.03.2024.
//

import SwiftUI

protocol TrackVisualizationViewModeling {
    
}

struct TrackVisualizationView: View {
    @State var tracks: [Track]
//    @State var project: [Project]
    @State var currentTime: Double
    var body: some View {
        Text("\(tracks.count)")
        ForEach(tracks, id: \.self) { track in
            Text((track.sound?.emoji) ?? "don't have an emoji")
            
//            Text("\(track.points.count)")
//                .font(.largeTitle)
//            ForEach(track.points, id: \.self) { point in
//                Text("\(point.volume)")
//                    .font(.largeTitle)
//            }
            
//            ForEach(track.points, id: \.self) { point in
//
//            }
        }
    }
}

//#Preview {
//    TrackVisualizationView(tracks: "1")
//}
