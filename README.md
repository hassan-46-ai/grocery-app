# Grocery app – Flutter

## Run
```bash
cd fresh_cart
flutter create .        # generates android/ios/web folders (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run
```

## Structure
- `core/`    theme (light + dark palette), animations, helpers
- `data/`    models + product catalog (replace with your API)
- `state/`   AppState (Provider): auth, cart, favourites, orders, filters, theme
- `widgets/` reusable UI
- `screens/` one file per screen

## Notes
- Poppins is loaded with `google_fonts` (needs internet the first time).
- Product/onboarding pictures are emoji placeholders. To use the real images from
  your Figma, export them to `assets/`, declare them in pubspec and swap the `Text(emoji)`
  inside `ProductCard`, `CategoryTile` and `OnboardingScreen` with `Image.asset`.
- Demo promo code: `FRESH10`. Login accepts any valid phone + 6+ char password.
