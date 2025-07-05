import SwiftUICore
import SwiftUI
import SwiftData

struct MainTabBar: View {
    @State private var selectedTab = 0
    @State private var forceUpdate = false
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.layoutDirection) private var layoutDirection

    var body: some View {
        ZStack {
            Color(.color1).ignoresSafeArea(.all) // Background color

            VStack {
                Spacer()

                // Show different views based on selected tab
                if selectedTab == 0 {
                    Home()
                } else if selectedTab == 1 {
                    Chat(viewModel: favoritesViewModel)
                } else if selectedTab == 2 {
                    Favorites(viewModel: favoritesViewModel) // Pass viewModel here
                } else if selectedTab == 3 {
                    Setting()
                }

                // Custom Tab Bar
                CustomTabBarView(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .id(forceUpdate) // Force view update when language changes
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            forceUpdate.toggle() // Toggle to force view update
        }
        .environment(\.layoutDirection, localizationManager.isRTL ? .rightToLeft : .leftToRight)
    }
}

#Preview {
    MainTabBar()
}
