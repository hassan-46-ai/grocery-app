# Hammad Stores - Flutter grocery app

## Run
```bash
cd fresh_cart
flutter create .        
flutter pub get
flutter run
```

## application features
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
