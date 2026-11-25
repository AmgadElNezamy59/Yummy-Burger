import SwiftUI

/// Home: browse, filter and search every recipe.
struct RecipesView: View {
    @State private var path: [Recipe] = []
    @State private var searchText = ""
    @State private var category: Recipe.Category?
    @State private var surprises = 0
    @Namespace private var namespace

    private var results: [Recipe] {
        Recipe.all.filter { recipe in
            (category == nil || recipe.category == category) && recipe.matches(searchText)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Category", selection: $category.animation(.snappy)) {
                        Text("All").tag(Recipe.Category?.none)
                        ForEach(Recipe.Category.allCases) { category in
                            Text(category.rawValue).tag(Optional(category))
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    if results.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                            .padding(.top, 40)
                    } else {
                        RecipeGrid(recipes: results, namespace: namespace)
                    }
                }
                .padding(.bottom, 24)
            }
            .navigationTitle("Yummy Burger")
            .searchable(text: $searchText, prompt: "Recipes or ingredients")
            .toolbar {
                Button("Surprise Me", systemImage: "dice") {
                    if let recipe = Recipe.all.randomElement() {
                        surprises += 1
                        path = [recipe]
                    }
                }
                .sensoryFeedback(.impact, trigger: surprises)
            }
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeDetailView(recipe: recipe)
                    .navigationTransition(.zoom(sourceID: recipe.id, in: namespace))
            }
        }
    }
}
