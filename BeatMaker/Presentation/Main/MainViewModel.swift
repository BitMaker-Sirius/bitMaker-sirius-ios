//
//  MainViewModel.swift
//  BeatMaker
//
//  Created by 1 on 21.03.2024.
//

import Foundation
import SwiftUI

enum MainViewEvent {
    case onLoadData
    
    case tapCreateProjectButton
    case tapRightProjectButton(projectId: String)
    case tapEditing
    case tapDeleteButton(projectId: String)
}

struct MainViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var projectsList: [Project]
    var isEditing: Bool
}

protocol MainViewModel: ObservableObject {
    var state: MainViewState { get }
    
    func handle(_ event: MainViewEvent)
}

final class MainViewModelImp: MainViewModel {
    @Environment(\.router) var router: Router
    @Published var state = MainViewState(
        indicatorViewState: .loading,
        projectsList: [],
        isEditing: false
    )
    
    let projectsListProvider: ProjectsListProvider
    let projectPlaybackService: any ProjectPlaybackService
    
    init(
        projectsListProvider: ProjectsListProvider,
        projectPlaybackService: any ProjectPlaybackService
    ) {
        self.projectsListProvider = projectsListProvider
        self.projectPlaybackService = projectPlaybackService
    }
    
    func handle(_ event: MainViewEvent) {
        switch event {
        case .onLoadData:
            loadData()
        case .tapCreateProjectButton:
            stopProcess()
            toProjectEditorView(with: nil)
        case .tapRightProjectButton(let projectId):
            stopProcess()
            if state.isEditing {
                toProjectEditorView(with: projectId)
            } else {
                toPlayProjectView(with: projectId)
            }
        case .tapEditing:
            state.isEditing.toggle()
        case .tapDeleteButton(let projectId):
            delete(by: projectId)
        }
    }
    
    private func loadData() {
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
    
    private func delete(by projectId: String) {
        projectsListProvider.delete(by: projectId) { [weak self] isCompleted in
            if isCompleted {
                guard let index = self?.state.projectsList.firstIndex(where: { $0.id == projectId }) else {
                    return
                }
                
                self?.state.projectsList.remove(at: index)
            }
        }
    }
    
    private func stopProcess() {
        state.projectsList = []
        state.isEditing = false
    }
    
    // MARK: Routing
    
    private func toProjectEditorView(with projectId: String?) {
        router.path.append(Route.projectEditor(projectId: projectId))
    }
    
    private func toPlayProjectView(with projectId: String) {
        router.path.append(Route.playProject(projectId: projectId))
    }
}
