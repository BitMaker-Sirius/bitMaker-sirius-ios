//
//  TrackVisualizationView.swift
//  BeatMaker
//
//  Created by Ирина Печик on 27.03.2024.
//

import SwiftUI

struct TrackVisualizationView<ViewModel: PlayProjectViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var zStackSize: CGSize = .zero
    
    var debug: String {
        "\(zStackSize)"
    }


    var body: some View {
        ZStack {
            ForEach(viewModel.state.project!.tracks, id: \.self) { track in
                ForEach(track.points, id: \.startTime) { point in
                    if viewModel.state.isPlaying && point.startTime <= viewModel.state.currentTime && viewModel.state.currentTime <= point.startTime + 5 {
                        Text((track.sound?.emoji) ?? "😇")
                            .font(.system(size: max(40, (point.volume ?? 10) * 100)))
                            .offset(
                                x: CGFloat.random(in: -(zStackSize.width / 2)...(zStackSize.width / 2)),
                                y: CGFloat.random(in: -(zStackSize.height / 2)...(zStackSize.height / 2))
                            )
                            .opacity(max(0.6, (point.pitch! + 2400) / (2400 + 2400)))
                            .animation(.easeInOut(duration: 2))
                    }                    
                }
            }
        }
        .frame(maxWidth: 500, maxHeight: 500)
        .background(
            GeometryReader(content: { geometry in
                Path { _ in
                    DispatchQueue.main.async  {
                        self.zStackSize = geometry.size
                        print(self.zStackSize)
                    }
                }
            })
        )
    }
}

