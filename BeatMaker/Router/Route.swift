import Foundation

enum Route: Hashable {
    case main
    case projectEditor(projectId: String?)
    case playProject(projectId: String)
    case soundsList(projectId: String)
}
