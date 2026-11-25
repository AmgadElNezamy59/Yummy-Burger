import SwiftUI

/// Adaptive grid of recipe cards: one column on iPhone, more on wider screens.
struct RecipeGrid: View {
    let recipes: [Recipe]
    let namespace: Namespace.ID

    private let columns = [GridItem(.adaptive(minimum: 300), spacing: 20)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(recipes) { recipe in
                NavigationLink(value: recipe) {
                    RecipeCard(recipe: recipe)
                }
                .buttonStyle(PressableButtonStyle())
                .matchedTransitionSource(id: recipe.id, in: namespace) {
                    $0.clipShape(.rect(cornerRadius: RecipeCard.cornerRadius, style: .continuous))
                }
                .overlay(alignment: .topTrailing) {
                    FavoriteButton(recipe: recipe)
                        .buttonStyle(CircleIconButtonStyle())
                        .padding(12)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct RecipeCard: View {
    static let cornerRadius: CGFloat = 24

    let recipe: Recipe

    var body: some View {
        Color.clear
            .aspectRatio(4 / 3, contentMode: .fit)
            .overlay {
                Image(decorative: recipe.imageName)
                    .resizable()
                    .scaledToFill()
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    HStack(spacing: 14) {
                        Label(recipe.formattedTime, systemImage: "clock")
                        Label("Serves \(recipe.servings)", systemImage: "person.2")
                        Label(recipe.category.rawValue, systemImage: recipe.category.symbol)
                    }
                    .font(.subheadline.weight(.medium))
                    .labelStyle(CompactLabelStyle())
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                }
                .foregroundStyle(.white)
                .padding(16)
                .padding(.top, 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    LinearGradient(colors: [.clear, .black.opacity(0.75)], startPoint: .top, endPoint: .bottom)
                }
            }
            .clipShape(.rect(cornerRadius: Self.cornerRadius, style: .continuous))
            .contentShape(.rect(cornerRadius: Self.cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
    }
}

/// Icon and title with a tighter gap than the default label.
struct CompactLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 4) {
            configuration.icon
            configuration.title
        }
    }
}

/// Gives cards a gentle squeeze when pressed.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.snappy(duration: 0.2), value: configuration.isPressed)
    }
}
