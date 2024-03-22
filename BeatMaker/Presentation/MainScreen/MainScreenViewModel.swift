//
//  MainScreenViewModel.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import Foundation

enum MainScreenViewEvent {
    case tapCreateTrackButton
}

struct MainScreenViewState {
    var shouldShowCreateTrackScreen: Bool
}

protocol MainScreenViewObservable: ObservableObject {
    var state: MainScreenViewState { get }
    
    func handle(_ event: MainScreenViewEvent)
}

class MainScreenViewModel: MainScreenViewObservable {
    @Published
    var state = MainScreenViewState(
        shouldShowCreateTrackScreen: false
    )
    
    init() {
        self.state = state
    }
    
    func handle(_ event: MainScreenViewEvent) {
        switch event {
        case .tapCreateTrackButton:
            print("tapCreateTrackButton")
//            state.shouldShowCreateTrackScreen.toggle()
        }
    }
}
