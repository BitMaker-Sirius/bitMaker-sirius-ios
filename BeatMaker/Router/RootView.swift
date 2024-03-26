import SwiftUI

struct RootView: View {
  @Environment(\.router)
  var router: Router

  var body: some View {
    let path = Binding {
      router.path
    } set: { value, _ in
      router.path = value
    }
    NavigationStack(path: path){
      router.viewForRoute(.root)
        .navigationDestination(for: Route.self) { route in
          router.viewForRoute(route)
        }
    }
  }
}

#Preview {
  RootView()
}
