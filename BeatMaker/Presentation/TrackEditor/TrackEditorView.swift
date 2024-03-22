//
//  TrackEditorView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct TrackEditorView: View {
    @StateObject var viewModel = TrackEditorViewModel()
    let project: Project
    
    var body: some View {
        VStack {
            // some hardcode
            Text(project.name ?? "some hardcode").font(.title)
            
            if viewModel.selectedSounds.isEmpty {
                Text("Звуки не выбраны")
            } else {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(viewModel.selectedSounds) { sound in
                            // some hardcode
                            Text("Sound " + (sound.name ?? "some hardcode"))
                        }
                    }
                }.padding()
            }
            
            NavigationLink(destination: SoundListView(viewModel: SoundListViewModel(editorViewModel: viewModel, addedToTrackSounds: []))) {
                Text("Добавить звуки")
            }
        }
    }
}
