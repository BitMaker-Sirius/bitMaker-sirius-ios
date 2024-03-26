//
//  MainViewModel.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import Foundation
import SwiftUI

enum MainViewEvent {
    case tapCreateProjectButton
    case tapEditProjectButton(projectId: String)
    case tapPlayProjectButton(projectId: String)
}

struct MainViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var projectsList: [Project]
}

protocol MainViewModel: ObservableObject {
    var state: MainViewState { get }
    
    func handle(_ event: MainViewEvent)
    
    func loadData()
}

final class MainViewModelImp: MainViewModel {
    @Environment(\.router) var router: Router
    
    let projectsListProvider: ProjectsListProvider
    let projectPlaybackService: any ProjectPlaybackService
    
    @Published var state = MainViewState(
        indicatorViewState: .loading,
        projectsList: []
    )
    
    init(
        projectsListProvider: ProjectsListProvider,
        projectPlaybackService: any ProjectPlaybackService
    ) {
        self.projectsListProvider = projectsListProvider
        self.projectPlaybackService = projectPlaybackService
    }
    
    func handle(_ event: MainViewEvent) {
        switch event {
        case .tapCreateProjectButton:
            toProjectEditorView(with: nil)
        case .tapPlayProjectButton(let projectId):
            toPlayProjectView(with: projectId)
        case .tapEditProjectButton(projectId: let projectId):
            toProjectEditorView(with: projectId)
        }
    }
    
    func loadData() {
        state.indicatorViewState = .loading
        
        projectsListProvider.loadData { [weak self] result in
            switch result {
            case .success(let projectsList):
                self?.state.projectsList = projectsList
                self?.state.indicatorViewState = .display
            case .failure(_):
                self?.state.indicatorViewState = .error
            }
        }
    }
    
    private func toProjectEditorView(with projectId: String?) {
        router.path.append(Route.projectEditor(projectId: projectId))
    }
    
    private func toPlayProjectView(with projectId: String) {
        router.path.append(Route.playProject(projectId: projectId))
    }
}
