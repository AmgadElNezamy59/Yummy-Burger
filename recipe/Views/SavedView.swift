import SwiftUI

/// The recipes the user has hearted.
struct SavedView: View {
    @Environment(FavoritesStore.self) private var favorites
    @Namespace private var namespace

    /// Switches to the Recipes tab from the empty state.
    let browse: () -> Void

    var body: some View {
        NavigationStack {
            Group {
                if favorites.recipes.isEmpty {
                    ContentUnavailableView {
                        Label("No Saved Recipes", systemImage: "heart")
                    } description: {
                        Text("Tap the heart on any recipe and it'll be waiting for you here.")
                    } actions: {
                        Button("Browse Recipes", action: browse)
                            .buttonStyle(.borderedProminent)
                    }
                } else {
                    ScrollView {
                        RecipeGrid(recipes: favorites.recipes, namespace: namespace)
                            .padding(.vertical, 8)
                            .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Saved")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
                    .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
            }
        }
    }
}
