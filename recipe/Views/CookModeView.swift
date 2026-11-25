import SwiftUI

/// Full-screen, one-step-at-a-time view for cooking. Keeps the screen awake while open.
struct CookModeView: View {
    let recipe: Recipe
    @Binding var checked: Set<String>

    @Environment(\.dismiss) private var dismiss
    @State private var step = 0
    @State private var showsIngredients = false

    private var isLastStep: Bool { step == recipe.steps.count - 1 }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ProgressView(value: Double(step + 1), total: Double(recipe.steps.count))
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .animation(.snappy, value: step)
                    .accessibilityHidden(true)

                TabView(selection: $step) {
                    ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, text in
                        StepPage(number: index + 1, total: recipe.steps.count, text: text)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                controls
            }
            .navigationTitle(recipe.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Ingredients", systemImage: "checklist") { showsIngredients = true }
                }
            }
            .sheet(isPresented: $showsIngredients) {
                ingredientsSheet
            }
        }
        .sensoryFeedback(.selection, trigger: step)
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.snappy) { step -= 1 }
            } label: {
                Label("Back", systemImage: "chevron.left")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(step == 0)

            Button {
                if isLastStep {
                    dismiss()
                } else {
                    withAnimation(.snappy) { step += 1 }
                }
            } label: {
                Text(isLastStep ? "Finish" : "Next")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .font(.headline)
        .controlSize(.large)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    private var ingredientsSheet: some View {
        NavigationStack {
            ScrollView {
                IngredientList(recipe: recipe, checked: $checked)
                    .padding(20)
            }
            .navigationTitle("Ingredients")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") { showsIngredients = false }
                    .fontWeight(.semibold)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

private struct StepPage: View {
    let number: Int
    let total: Int
    let text: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Step \(number) of \(total)")
                    .font(.headline)
                    .foregroundStyle(.tint)
                Text(text)
                    .font(.title2.weight(.medium))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: 640, alignment: .leading)
            .padding(24)
            .frame(maxWidth: .infinity)
        }
        .scrollBounceBehavior(.basedOnSize)
        .accessibilityElement(children: .combine)
    }
}
