import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    @State private var checked: Set<String> = []
    @State private var isCooking = false
    @State private var isPastHero = false

    private let heroHeight: CGFloat = 380

    /// iOS 26 draws toolbar buttons on glass, which reads well over the photo, so the bar
    /// only appears once the photo has scrolled away. Earlier versions keep a solid bar.
    private var showsBarBackground: Bool {
        if #available(iOS 26, *) { return isPastHero }
        return true
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                StretchyHeader(imageName: recipe.imageName, height: heroHeight)

                content
                    .frame(maxWidth: 680, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 28)
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        Color(.systemBackground),
                        in: .rect(topLeadingRadius: 28, topTrailingRadius: 28, style: .continuous)
                    )
                    .padding(.top, -28)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.contentOffset.y > heroHeight - 120
        } action: { _, isPast in
            withAnimation(.easeInOut(duration: 0.2)) { isPastHero = isPast }
        }
        .navigationTitle(isPastHero ? recipe.title : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(showsBarBackground ? .visible : .hidden, for: .navigationBar)
        .toolbar {
            ShareLink(item: recipe.shareText, subject: Text(recipe.title))
            FavoriteButton(recipe: recipe)
        }
        .fullScreenCover(isPresented: $isCooking) {
            CookModeView(recipe: recipe, checked: $checked)
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 10) {
                CategoryBadge(category: recipe.category)
                Text(recipe.title)
                    .font(.largeTitle.bold())
                Text(recipe.summary)
                    .foregroundStyle(.secondary)
            }

            facts

            Button {
                isCooking = true
            } label: {
                Label("Start Cooking", systemImage: "frying.pan.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    SectionTitle("Ingredients")
                    Spacer()
                    if !checked.isEmpty {
                        Button("Clear") {
                            withAnimation(.snappy) { checked.removeAll() }
                        }
                        .font(.subheadline.weight(.semibold))
                        .transition(.opacity)
                    }
                }
                IngredientList(recipe: recipe, checked: $checked)
            }

            VStack(alignment: .leading, spacing: 20) {
                SectionTitle("Method")
                ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                    StepRow(number: index + 1, text: step)
                }
            }
        }
    }

    private var facts: some View {
        HStack(spacing: 0) {
            Fact(symbol: "clock", value: recipe.formattedTime, label: "Total time")
            Divider()
            Fact(symbol: "person.2", value: "\(recipe.servings)", label: "Servings")
            Divider()
            Fact(symbol: "basket", value: "\(recipe.ingredientCount)", label: "Ingredients")
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 20, style: .continuous))
    }
}

// MARK: - Pieces

/// Photo header that stretches when you pull down.
private struct StretchyHeader: View {
    let imageName: String
    let height: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let stretch = max(0, proxy.frame(in: .scrollView).minY)
            Image(decorative: imageName)
                .resizable()
                .scaledToFill()
                .frame(width: proxy.size.width, height: height + stretch)
                .clipped()
                .offset(y: -stretch)
        }
        .frame(height: height)
    }
}

private struct CategoryBadge: View {
    let category: Recipe.Category

    private var color: Color { category == .veggie ? .green : .brand }

    var body: some View {
        Label(category.rawValue, systemImage: category.symbol)
            .labelStyle(CompactLabelStyle())
            .font(.caption.weight(.bold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.14), in: .capsule)
    }
}

private struct Fact: View {
    let symbol: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .padding(.bottom, 2)
            Text(value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 4)
        .accessibilityElement(children: .combine)
    }
}

private struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.title2.bold())
            .accessibilityAddTraits(.isHeader)
    }
}

private struct StepRow: View {
    let number: Int
    let text: String

    @ScaledMetric private var badgeSize: CGFloat = 28

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Text("\(number)")
                .font(.subheadline.bold())
                .foregroundStyle(.white)
                .frame(width: badgeSize, height: badgeSize)
                .background(.tint, in: .circle)
            Text(text)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 3)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(number). \(text)")
    }
}
