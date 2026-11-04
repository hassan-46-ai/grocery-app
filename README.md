# Hammad Stores - Flutter grocery app

## Run
```bash
cd fresh_cart
flutter create .        # generates android/ios folders (keeps lib/, assets/ and pubspec.yaml)
flutter pub get
# follow MAPS_SETUP.md once (API key + permissions)
flutter run
```

## Features
Animated splash, onboarding, login/sign up, home, categories with sub-category sidebar, product details,
favourites, cart, checkout with approval + success dialog, orders, profile (name, phone, address, avatar),
filters, search, **EGP prices**, **Arabic / English with RTL**, **dark / light mode**, **Google Maps location picker**.

## Structure
- `core/`    theme (light + dark), localisation (`strings_ar.dart`), animations, image helper, utils
- `data/`    models + product catalog (`catalog.dart`) - replace with your API
- `state/`   AppState (Provider)
- `widgets/` reusable UI
- `screens/` one file per screen
- `assets/`  product photos (`assets/products/IMAGE_NAMES.txt` lists the exact file names)

## Customising
- Products / prices / Arabic names: `lib/data/catalog.dart` (price, old price in EGP).
- Product photo: save `assets/products/<slug>.png|jpg|webp` (slug = English name in lowercase with `_`). Missing photos fall back to emoji.
- Logo: save `assets/brand/logo.png`. Onboarding art: `assets/onboarding/1.png, 2.png, 3.png` (see IMAGE_NAMES.txt).
- New text: write it in English in the code and add the Arabic line to `lib/core/strings_ar.dart`.
- Demo promo code: `FRESH10`.
