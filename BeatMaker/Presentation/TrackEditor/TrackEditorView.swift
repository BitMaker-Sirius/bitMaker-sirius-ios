//
//  TrackEditorView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct TrackEditorView: View {
    @StateObject var viewModel = TrackEditorViewModel()
    let track: Track
    
    var body: some View {
        VStack {
            Text(track.name).font(.title)
            Text(track.description).font(.body)
                .padding(.bottom, 50)
            
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
struct TrackEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TrackEditorView(track: Track(name: "Трек", description: "Описание"))
    }
}
