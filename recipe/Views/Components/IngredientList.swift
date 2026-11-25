import SwiftUI

/// Tappable ingredient checklist, grouped by section. Shared by the recipe page and Cook Mode
/// so ticks carry over between them.
struct IngredientList: View {
    let recipe: Recipe
    @Binding var checked: Set<String>

    @State private var taps = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { groupIndex, group in
                VStack(alignment: .leading, spacing: 14) {
                    if let title = group.title {
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                    }
                    ForEach(Array(group.items.enumerated()), id: \.offset) { itemIndex, item in
                        let key = "\(groupIndex)-\(itemIndex)"
                        IngredientRow(text: item, isChecked: checked.contains(key)) {
                            taps += 1
                            withAnimation(.snappy) {
                                if checked.remove(key) == nil { checked.insert(key) }
                            }
                        }
                    }
                }
            }
        }
        .sensoryFeedback(.selection, trigger: taps)
    }
}

private struct IngredientRow: View {
    let text: String
    let isChecked: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isChecked ? AnyShapeStyle(.tint) : AnyShapeStyle(.tertiary))
                    .contentTransition(.symbolEffect(.replace))
                Text(text)
                    .strikethrough(isChecked)
                    .foregroundStyle(isChecked ? .secondary : .primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isChecked ? .isSelected : [])
    }
}
