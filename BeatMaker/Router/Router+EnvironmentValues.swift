import Foundation
import SwiftUI

private struct RouterKey: EnvironmentKey {
    static var defaultValue: Router = Router(assembly: Assembly())
}

extension EnvironmentValues {
    var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
