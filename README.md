# sandwich_shop

University lab project to learn Flutter — a small interactive sandwich counter app.

## Features
- Display a sandwich order with:
  - Adjustable quantity (Add / Remove)
  - Switch between footlong and six-inch sizes
  - Select bread type (white, wheat, wholemeal)
  - Add an order note (e.g., "no onions")
- Maximum quantity enforced by `OrderScreen(maxQuantity: X)`
- Simple, reusable UI components:
  - `OrderItemDisplay` (shows quantity, type, bread, note)
  - `StyledButton` (styled add/remove buttons)

## Project structure (relevant files)
- lib/
  - main.dart — app entry point, `OrderScreen` state and UI
  - views/app_styles.dart — styles used by the app (imported as `package:sandwich_shop/views/app_styles.dart`)
  - repositories/order_repository.dart — small repository used by `OrderScreen`
- pubspec.yaml — project configuration (name must match `package:` imports)

## Prerequisites
- Flutter SDK (stable) installed and on PATH
- Dart SDK (bundled with Flutter)
- (Optional) Android SDK / emulator or a connected device
- VS Code (recommended) with the Flutter and Dart extensions

## Install and run (Windows PowerShell)
1. Clone repository:
```powershell
git clone <https://github.com/ImNotGood69/flutter_attempt>
cd "c:\random revision stuff i cba to put into other drive\Flutter\flutter_attempt"
```
