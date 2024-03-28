//
//  TrackVisualizationView.swift
//  BeatMaker
//
//  Created by Ирина Печик on 27.03.2024.
//

import SwiftUI

protocol TrackVisualizationViewModeling {
    
}

struct TrackVisualizationView<ViewModel: PlayProjectViewModel>: View {
    @ObservedObject var viewModel: ViewModel
//    @State var tracks: [Track]
//    @State var project: [Project]
//    @State var playbackTimer: Timer
    var body: some View {
        Text("\((viewModel.state.project?.tracks.count)!)")
        Text("\(viewModel.state.currentTime)")
        ForEach(viewModel.state.project!.tracks, id: \.self) { track in
            Text((track.sound?.emoji) ?? "don't have an emoji")
            ForEach(track.points, id: \.startTime) { point in
                Text("\(point.startTime)")
            }
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
