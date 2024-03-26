import Foundation

enum Route: Hashable {
    case main
    case projectEditor(projectId: String?)
}
