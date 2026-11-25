import Foundation

/// A burger recipe bundled with the app.
struct Recipe: Identifiable, Hashable {
    enum Category: String, CaseIterable, Identifiable {
        case meat = "Meat"
        case veggie = "Veggie"

        var id: Self { self }

        var symbol: String {
            switch self {
            case .meat: "flame.fill"
            case .veggie: "leaf.fill"
            }
        }
    }

    /// A titled block of ingredients, e.g. "For the sauce". The main block has no title.
    struct IngredientGroup: Hashable {
        var title: String?
        var items: [String]
    }

    /// Stable identifier. Also the name of the recipe's photo in the asset catalog.
    let id: String
    let title: String
    let summary: String
    let category: Category
    let minutes: Int
    let servings: Int
    let ingredients: [IngredientGroup]
    let steps: [String]

    var imageName: String { id }

    var ingredientCount: Int {
        ingredients.reduce(0) { $0 + $1.items.count }
    }

    /// "25 min", "1 hr", "3 hr 15 min"
    var formattedTime: String {
        let (hours, mins) = minutes.quotientAndRemainder(dividingBy: 60)
        switch (hours, mins) {
        case (0, _): return "\(mins) min"
        case (_, 0): return "\(hours) hr"
        default: return "\(hours) hr \(mins) min"
        }
    }

    func matches(_ query: String) -> Bool {
        let query = query.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else { return true }
        return title.localizedStandardContains(query)
            || ingredients.contains { $0.items.contains { $0.localizedStandardContains(query) } }
    }

    /// Plain-text version of the recipe for sharing.
    var shareText: String {
        var lines = [title, summary, "", "Serves \(servings) · \(formattedTime)", "", "INGREDIENTS"]
        for group in ingredients {
            if let title = group.title { lines.append("\n\(title)") }
            lines += group.items.map { "• \($0)" }
        }
        lines += ["", "METHOD"]
        lines += steps.enumerated().map { "\($0.offset + 1). \($0.element)" }
        lines += ["", "Shared from Yummy Burger 🍔"]
        return lines.joined(separator: "\n")
    }
}
