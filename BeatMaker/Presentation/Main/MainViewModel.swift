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
    
    case tapListenProject(projectId: String)
    case tapEditProject(projectId: String)
    
    case scrollUp(delta: CGFloat)
    case scrollDown(delta: CGFloat)
}

struct MainViewState: BaseViewState {
    var indicatorViewState: IndicatorViewState
    var projectsList: [Project]
    var projectsListHeight: CGFloat
    var isEditing: Bool
    var allImages: [String: UIImage]
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
        projectsListHeight: 0,
        isEditing: false,
        allImages: [:]
    )
    

    let projectsListProvider: ProjectsListProvider
    let projectPlaybackService: any ProjectPlaybackService
    let fileManager: FileManagerProtocol
    
    init(
        projectsListProvider: ProjectsListProvider,
        projectPlaybackService: any ProjectPlaybackService,
        fileManager: FileManagerProtocol
    ) {
        self.projectsListProvider = projectsListProvider
        self.projectPlaybackService = projectPlaybackService
        self.fileManager = fileManager
        fileManager.readAllImages{ [weak self] array in
            guard let self else {
                return
            }
            for element in array {
                self.state.allImages[element.id] = element.image
            }
        }
    }
    
    func handle(_ event: MainViewEvent) {
        switch event {
        case .onLoadData:
            loadData()
        case .tapCreateProjectButton:
            toProjectEditorView(with: nil)
            stopProcess()
        case .tapListenProject(projectId: let projectId):
            toPlayProjectView(with: projectId)
        case .tapEditProject(projectId: let projectId):
            toProjectEditorView(with: projectId)
        case .tapRightProjectButton(let projectId):
            if state.isEditing {
                toProjectEditorView(with: projectId)
            } else {
                toPlayProjectView(with: projectId)
            }
            stopProcess()
        case .tapEditing:
            state.isEditing.toggle()
        case .tapDeleteButton(let projectId):
            delete(by: projectId)
        case .scrollDown(let delta):
            state.projectsListHeight = CGFloat(
                max(
                    state.projectsListHeight - delta,
                    startHeight
                )
            )
        case .scrollUp(let delta):
            state.projectsListHeight = CGFloat(
                min(
                    state.projectsListHeight + delta,
                    maxHeight
                )
            )
        }
    }
    
    private func loadData() {
        
        fileManager.readAllImages{ [weak self] array in
            guard let self else {
                return
            }
            for element in array {
                self.state.allImages[element.id] = element.image
            }
        }
        
        state.indicatorViewState = .loading
        
        projectsListProvider.loadData { [weak self] result in
            switch result {
                case .success(let projectsList):
                    self?.state.projectsList = projectsList
                    self?.state.indicatorViewState = .display
                    self?.state.projectsListHeight = self?.getActualTrackListHeight() ?? 0
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
                self?.state.projectsListHeight = self?.getActualTrackListHeight() ?? 0
            }
        }
    }
    
    private func getActualTrackListHeight() -> CGFloat {
        if state.projectsList.isEmpty {
            return Constants.emptyTrackListHeight
        }
        
        return min(
            CGFloat(
                state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height / 2)
        )
    }
    
    private var startHeight: CGFloat {
        if state.projectsList.isEmpty {
            return Constants.emptyTrackListHeight
        }
        
        return min(
            CGFloat(
                state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height / 2)
        )
    }
    
    private var maxHeight: CGFloat {
        if state.projectsList.isEmpty {
            return Constants.emptyTrackListHeight
        }
        
        return min(
            CGFloat(
                state.projectsList.count * Constants.trackRowHeight
                + Constants.spacerHeight * (state.projectsList.count - 1)
                + Constants.listTitleHeight
            ),
            CGFloat(UIScreen.main.bounds.height)
        )
    }
    
    private func stopProcess() {
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
