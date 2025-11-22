# sandwich_shop

Small university lab project to learn Flutter — an interactive sandwich counter app.

## Features
- Display a sandwich order with:
  - Adjustable quantity (Add / Remove)
  - Switch between footlong and six-inch sizes
  - Select bread type (white, wheat, wholemeal)
  - Option to toggle toasted / untoasted
  - Add an order note (e.g., "no onions")
- Maximum quantity enforced by `OrderScreen(maxQuantity: X)`
- Reusable UI components:
  - `OrderItemDisplay` (shows quantity, size, bread, note)
  - `StyledButton` (styled add/remove buttons)

## Project structure (relevant)
- lib/
  - main.dart — app entry point, `OrderScreen` state and UI
  - views/app_styles.dart — shared styles (import: `package:sandwich_shop/views/app_styles.dart`)
  - repositories/
    - order_repository.dart
    - pricing_repository.dart — pricing logic (footlong £11, six-inch £7)
- test/ — unit and widget tests
- pubspec.yaml — project configuration (package name must match `package:` imports)

## Prerequisites
- Flutter SDK (stable) installed and on PATH
- Dart SDK (bundled with Flutter)
- Optional: Android SDK / emulator or a connected device
- Recommended: VS Code with Flutter & Dart extensions

## Install and run (Windows PowerShell)
1. Clone repository and open project:
```powershell
git clone <your-repo-url>
cd "c:\random revision stuff i cba to put into other drive\Flutter\flutter_attempt"
code .
```
2. Verify Flutter and devices:
```powershell
flutter doctor -v
flutter devices
```
3. Get packages and run:
```powershell
flutter pub get
flutter run
# or target a device: flutter run -d <deviceId>
```

## Tests
Run all tests:
```powershell
flutter test
```
Tips:
- Widget tests that find widgets by text may need `.last` if the same text appears multiple times.
- Restart Dart analysis server in VS Code if imports or edits are not recognized.

## Notes / Troubleshooting
- Package imports (for example `package:sandwich_shop/views/app_styles.dart`) require the `name` field in `pubspec.yaml` to match `sandwich_shop`. Either set that name or use relative imports (e.g., `import 'views/app_styles.dart';`).
- If `flutter run` works in a terminal but not in VS Code, start VS Code from the working terminal (`code .`) so the PATH is inherited, or restart VS Code after changing PATH.
- If commits or runs are slow, check pre-commit hooks, Git LFS, antivirus, or large staged files.

## Customization
- Change max quantity: `OrderScreen(maxQuantity: 5)`
- Edit prices: `lib/repositories/pricing_repository.dart` (defaults: footlong £11, six-inch £7)
- Add bread options: update `BreadType` enum in `main.dart`

## Contributing
This is an educational project. Open issues or PRs for fixes and improvements.

## License
Add a LICENSE file if you intend to publish or share under a specific license.
