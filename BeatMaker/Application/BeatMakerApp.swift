//
//  BeatMakerApp.swift
//  BeatMaker
//
//  Created by Nik Y on 20.03.2024.
//

import SwiftUI

@main
struct BeatMakerApp: App {
    @Environment(\.router) var router: Router
    
    var body: some Scene {
        WindowGroup {
            router.assembly.rootView()
        }
    }
}
// trigger unit tests
