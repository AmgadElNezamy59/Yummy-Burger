# Yummy Burger

Discover the best burger recipes 🤤

A small, offline SwiftUI app for iPhone and iPad (iOS 18+).

## What it does

- **Browse** handpicked burger recipes, filter by Meat or Veggie.
- **Search** by recipe name or by an ingredient you already have.
- **Save** favourites with a tap; they stay saved between launches.
- **Tick off ingredients** as you shop or prep.
- **Cook Mode**: one big step at a time, swipe or tap through, and the screen stays awake.
- **Share** any recipe as plain text.
- **Surprise Me** picks a random recipe when you can't decide.

## Project layout

```
recipe/
  YummyBurgerApp.swift        App entry, tabs, brand tint
  Model/
    Recipe.swift              Recipe model
    Recipe+Data.swift         The bundled recipes
    FavoritesStore.swift      Saved recipes (UserDefaults)
  Views/
    WelcomeView.swift         First-launch screen
    RecipesView.swift         Home: grid, filter, search
    SavedView.swift           Saved recipes + empty state
    RecipeDetailView.swift    Photo header, facts, ingredients, method
    CookModeView.swift        Step-by-step cooking
    Components/               Recipe grid & card, favourite button, ingredient checklist
  Assets.xcassets             App icon, accent colour, recipe photos
  PrivacyInfo.xcprivacy       Privacy manifest (UserDefaults only, no tracking)
```

The Xcode project uses a synchronized folder, so new files added under `recipe/` are picked up automatically.

## Adding a recipe

1. Add a photo to `Assets.xcassets/Recipes`, named with the recipe's `id` (e.g. `smash-burger`).
2. Add a `Recipe(...)` entry to `Recipe+Data.swift` with the same `id`.
