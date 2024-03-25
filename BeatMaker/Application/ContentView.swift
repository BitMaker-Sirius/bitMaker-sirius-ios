//
//  ContentView.swift
//  BeatMaker
//
//  Created by Александр Фофонов on 24.03.2024.
//

import SwiftUI

struct ContentView: View {
    // В качестве примера обращения с di
    @Environment(\.assembly) var assembly
    
    var body: some View {
        TrackListView()
    }
}
