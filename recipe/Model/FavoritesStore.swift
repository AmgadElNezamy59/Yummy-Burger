import Foundation
import Observation

/// Remembers which recipes the user saved. Persisted in UserDefaults —
/// a handful of IDs doesn't need anything heavier.
@Observable
final class FavoritesStore {
    private static let key = "favoriteRecipeIDs"

    private(set) var ids: Set<String>
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        ids = Set(defaults.stringArray(forKey: Self.key) ?? [])
    }

    func contains(_ recipe: Recipe) -> Bool {
        ids.contains(recipe.id)
    }

    func toggle(_ recipe: Recipe) {
        if ids.remove(recipe.id) == nil {
            ids.insert(recipe.id)
        }
        defaults.set(ids.sorted(), forKey: Self.key)
    }

    /// Saved recipes, in the same order as the full collection.
    var recipes: [Recipe] {
        Recipe.all.filter { ids.contains($0.id) }
    }
}
