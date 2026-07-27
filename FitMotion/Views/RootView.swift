import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Inicio", systemImage: "house.fill") }
            NavigationStack { ExploreView() }
                .tabItem { Label("Explorar", systemImage: "square.grid.2x2.fill") }
            NavigationStack { RoutineView() }
                .tabItem { Label("Mi rutina", systemImage: "figure.strengthtraining.traditional") }
        }
        .tint(.fmLime)
    }
}
