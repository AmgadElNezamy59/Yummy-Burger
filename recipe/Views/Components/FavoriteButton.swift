import SwiftUI

/// Heart toggle that saves a recipe. Style it with `.buttonStyle(...)` where it's placed.
struct FavoriteButton: View {
    @Environment(FavoritesStore.self) private var favorites
    let recipe: Recipe

    @State private var taps = 0

    var body: some View {
        let isFavorite = favorites.contains(recipe)

        Button {
            taps += 1
            withAnimation(.snappy) { favorites.toggle(recipe) }
        } label: {
            Label(isFavorite ? "Remove from Saved" : "Save", systemImage: isFavorite ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .contentTransition(.symbolEffect(.replace))
        }
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }
}

/// Round, translucent icon button for use on top of photos.
struct CircleIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(.black.opacity(0.35), in: .circle)
            .background(.ultraThinMaterial, in: .circle)
            .scaleEffect(configuration.isPressed ? 0.88 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
            .contentShape(.circle)
    }
}
