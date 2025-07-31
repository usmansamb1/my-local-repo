# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
```bash
# Run the app in debug mode
flutter run

# Run the app on a specific device
flutter run -d <device_id>

# Hot reload (while app is running)
r

# Hot restart (while app is running)
R

# Build APK for Android
flutter build apk

# Build for iOS
flutter build ios

# Get dependencies
flutter pub get

# Analyze code
flutter analyze

# Run linter
flutter analyze --no-fatal-infos

# Format code
dart format .

# Run tests
flutter test

# Run a specific test file
flutter test test/widget_test.dart
```

## Architecture

This is a SASCO fuel station mobile app built with Flutter using a pure native approach with minimal external dependencies.

### Navigation Architecture
The app uses Flutter's native Navigator 2.0 with named routes defined in `lib/utils/constants.dart`. The navigation flow:
- Initial route: `/login` 
- Authentication flow: Login → Register/ForgotPassword → back to Login
- Main app flow: Login → `/main` (contains bottom navigation with 5 tabs)
- All routes are defined in `main.dart` using MaterialApp's routes map

### State Management
Pure Flutter approach using:
- `StatefulWidget` for local component state
- Mock `AuthService` singleton for authentication state
- No external state management libraries

### Screen Structure
The app implements 5 screens from a PDF design:
1. **Login Screen** - Phone number authentication with +966 prefix
2. **Register Screen** - Account creation with invitation code
3. **Forgot Password Screen** - SMS-based password recovery
4. **Main Screen** - Container with bottom navigation
5. **5 Tab Screens** - Home, Services, Scan, Balance, More

### Theme & Styling
- Custom theme defined in `lib/theme/app_theme.dart`
- SASCO brand colors: Primary #00A19C (teal), Secondary #0D7A77
- Material 3 design system
- RTL support ready for Arabic localization

### Key Implementation Details
- Phone number validation expects Saudi format (5XXXXXXXX)
- Mock authentication with 2-second delays simulating API calls
- Face ID/Touch ID integration points prepared but not implemented
- Language toggle UI present but localization not implemented
- All forms use Flutter's built-in form validation
- Custom reusable widgets in `lib/widgets/` for consistent UI

### Project Constraints
- **No external dependencies** beyond Flutter SDK and cupertino_icons
- Uses only native Flutter features
- Mock services instead of real API integration
- Biometric authentication prepared via MethodChannel (not implemented)