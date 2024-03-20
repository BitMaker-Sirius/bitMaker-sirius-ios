//
//  PlayTrackView.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

struct PlayTrackView: View {
    @StateObject var viewModel = TrackEditorViewModel()
    let track: Track
    
    var body: some View {
        Text("Play " + track.name)
    }
}

struct PlayTrackView_Previews: PreviewProvider {
    static var previews: some View {
        PlayTrackView(track: Track(name: "", description: ""))
    }
}
