import Foundation
import SwiftUI
import Observation

enum Route {
  case root
  case secondScreen
  case thirdScreen
}

@Observable
class Router {
  var path: NavigationPath

  init() {
    path = NavigationPath()
  }

  @ViewBuilder
  func viewForRoute(_ route: Route) -> some View {
    switch route {
    case .root:
      FirstView(viewModel: FirstViewModel(router: self))
    case .secondScreen:
      SecondScreen(viewModel: SecondScreenViewModel(router: self))
    case .thirdScreen:
      ThirdScreen(viewModel: ThirdScreenViewModel(router: self))
    }
  }
}

