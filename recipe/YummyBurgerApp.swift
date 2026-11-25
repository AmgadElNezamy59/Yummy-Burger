import SwiftUI

@main
struct YummyBurgerApp: App {
    @State private var favorites = FavoritesStore()
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false

    init() {
        Self.useRoundedNavigationTitles()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenWelcome {
                    RootView()
                        .transition(.opacity)
                } else {
                    WelcomeView {
                        withAnimation(.smooth) { hasSeenWelcome = true }
                    }
                    .transition(.opacity)
                }
            }
            .environment(favorites)
            .fontDesign(.rounded)
            .tint(.brand)
        }
    }

    /// SwiftUI's `fontDesign` doesn't reach UIKit-drawn navigation titles, so match them here.
    private static func useRoundedNavigationTitles() {
        func rounded(_ style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
            let base = UIFont.preferredFont(forTextStyle: style)
            let font = UIFont.systemFont(ofSize: base.pointSize, weight: weight)
            guard let descriptor = font.fontDescriptor.withDesign(.rounded) else { return font }
            return UIFont(descriptor: descriptor, size: base.pointSize)
        }
        let appearance = UINavigationBar.appearance()
        appearance.largeTitleTextAttributes = [.font: rounded(.largeTitle, weight: .bold)]
        appearance.titleTextAttributes = [.font: rounded(.headline, weight: .semibold)]
    }
}

extension Color {
    /// Tomato red from the asset catalog, used as the app-wide tint.
    static let brand = Color("AccentColor")
}

private struct RootView: View {
    enum AppTab { case recipes, saved }

    @State private var selection: AppTab = .recipes

    var body: some View {
        TabView(selection: $selection) {
            Tab("Recipes", systemImage: "fork.knife", value: .recipes) {
                RecipesView()
            }
            Tab("Saved", systemImage: "heart", value: .saved) {
                SavedView { selection = .recipes }
            }
        }
    }
}
