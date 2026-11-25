import SwiftUI

/// Shown once, on first launch.
struct WelcomeView: View {
    let getStarted: () -> Void

    @State private var hasAppeared = false

    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                photoFan
                    .padding(.top, 32)

                VStack(spacing: 10) {
                    Text("Yummy Burger")
                        .font(.largeTitle.weight(.heavy))
                    Text("Burger recipes worth getting messy for.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 22) {
                    Feature(
                        symbol: "magnifyingglass",
                        title: "Find your next favourite",
                        text: "Search by name, or by what's already in your fridge."
                    )
                    Feature(
                        symbol: "heart.fill",
                        title: "Save the keepers",
                        text: "Heart a recipe to keep it one tap away."
                    )
                    Feature(
                        symbol: "frying.pan.fill",
                        title: "Cook step by step",
                        text: "Big, clear steps, and your screen stays awake."
                    )
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 24)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) {
            Button(action: getStarted) {
                Text("Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .frame(maxWidth: 520)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.8, bounce: 0.35).delay(0.15)) { hasAppeared = true }
        }
    }

    private var photoFan: some View {
        let photos = ["black-bean", "double-cheeseburger", "lemon-herb-chicken"]
        return ZStack {
            ForEach(Array(photos.enumerated()), id: \.offset) { index, name in
                let position = Double(index - 1) // -1, 0, 1
                Image(decorative: name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 190)
                    .clipShape(.rect(cornerRadius: 26, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .strokeBorder(.white, lineWidth: 4)
                    }
                    .shadow(color: .black.opacity(0.18), radius: 14, y: 8)
                    .rotationEffect(.degrees(hasAppeared ? position * 12 : 0))
                    .offset(x: hasAppeared ? position * 90 : 0, y: hasAppeared ? abs(position) * 14 : 0)
                    .zIndex(index == 1 ? 1 : 0)
                    .scaleEffect(index == 1 ? 1.08 : 1)
            }
        }
        .frame(height: 230)
        .opacity(hasAppeared ? 1 : 0)
    }
}

private struct Feature: View {
    let symbol: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(.tint)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(text)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
