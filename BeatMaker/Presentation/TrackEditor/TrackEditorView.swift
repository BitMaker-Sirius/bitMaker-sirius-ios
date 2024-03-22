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
            Text(project.name).font(.title)
            
            if viewModel.selectedSounds.isEmpty {
                Text("Звуки не выбраны")
            } else {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(viewModel.selectedSounds) { sound in
                            Text("Sound " + sound.name)
                        }
                    }
                }.padding()
            }
            
            NavigationLink(destination: SoundListView(editorViewModel: viewModel)) {
                Text("Добавить звуки")
            }
        }
    }
}
