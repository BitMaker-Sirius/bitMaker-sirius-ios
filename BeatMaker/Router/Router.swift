import Foundation
import SwiftUI

@Observable final class Router {
    let assembly: Assembly
    var path: NavigationPath

    init(assembly: Assembly) {
        self.assembly = assembly
        self.path = NavigationPath()
    }

    @ViewBuilder
    func viewForRoute(_ route: Route) -> some View {
        switch route {
        case .main:
            assembly.mainView()
        case .projectEditor(let projectId):
            assembly.projectEditorView(projectId: projectId)
        case .playProject(projectId: let projectId):
            assembly.playProjectView(projectId: projectId)
        }
    }
}
