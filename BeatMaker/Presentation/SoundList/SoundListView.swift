//
//  SoundListView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct SoundListView: View {
    @StateObject var viewModel = SoundListViewModel()
    @ObservedObject var editorViewModel: TrackEditorViewModel
    
    var body: some View {
        List(viewModel.sounds) { sound in
            Text(sound.name)
                .padding()
                .background(editorViewModel.isSoundSelected(sound) ? Color.green : Color.clear)
                .cornerRadius(5)
                .onTapGesture {
                    editorViewModel.addOrRemoveSound(sound)
                }
        }
    }
}

//struct SoundListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundListView(editorViewModel: TrackEditorViewModel())
//    }
//}
