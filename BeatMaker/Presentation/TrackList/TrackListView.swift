//
//  ContentView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct TrackListView: View {
    @StateObject var viewModel = TrackListViewModel()
    
    @State private var trackPath: [Track] = []
    @State private var selectedTrack: Track?
    @State private var isShowingPlayTrackView = false
    @State private var isShowingEditTrackSheet = false
    
    var body: some View {
        NavigationStack(path: $trackPath) {
            VStack {
                LazyVStack {
                    ForEach(viewModel.tracks) { track in
                        VStack {
                            HStack {
                                Text(track.name)
                                Spacer()
                                Button {
                                    selectedTrack = track
                                    isShowingPlayTrackView = true
                                    print("Воспроизведение " + track.name)
                                } label: {
                                    Image(systemName: "play.circle")
                                }
                            }
                            Divider()
                        }
                        .padding()
                        .background()
                        .onTapGesture {
                            print("Tap on \(track.name)")
                            trackPath.append(track)
                        }
                        .onLongPressGesture {
                            selectedTrack = track
                            isShowingEditTrackSheet = true
                            print("Long press on \(track.name)")
                        }
                    }
                }
                
                Spacer()
            }
            .navigationDestination(for: Track.self, destination: { track in
                TrackEditorView(track: track)
            })
            .navigationDestination(isPresented: $isShowingPlayTrackView) {
                if let trackToPlay = selectedTrack {
                    PlayTrackView(track: trackToPlay)
                }
            }
            .sheet(isPresented: $isShowingEditTrackSheet) {
                if let trackForEditing = selectedTrack {
                    Text("Редактирование трека " + trackForEditing.name)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView()
    }
}
