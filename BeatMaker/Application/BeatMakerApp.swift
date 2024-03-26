//
//  BeatMakerApp.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

@main
struct BeatMakerApp: App {
    var body: some Scene {
        WindowGroup {
//            let mainScreenViewModel = MainScreenViewModel()
//            
//            MainScreenView(mainScreenViewModel: mainScreenViewModel)
            TrackEditorView(viewModel: TrackEditorViewModel())
        }
    }
}
