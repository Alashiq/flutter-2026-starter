# Flutter Flavors Guide

## Overview

This project uses Flutter flavors to support multiple environments (Development and Production). Each flavor has its own configuration including colors, API URLs, and app name.

## Available Flavors

### 🔵 Development (Dev)
- **Colors**: Blue/Purple theme
- **API URL**: `https://dev-api.yourapp.com`
- **App Name**: StarterApp (Dev)

### 🟢 Production (Prod)
- **Colors**: Teal/Green theme
- **API URL**: `https://api.yourapp.com`
- **App Name**: StarterApp

## Running the App

### Development Flavor
```bash
flutter run -t lib/main_dev.dart
```

### Production Flavor
```bash
flutter run -t lib/main_prod.dart
```

## Building the App

### Build APK (Android)
```bash
# Development
flutter build apk -t lib/main_dev.dart

# Production
flutter build apk -t lib/main_prod.dart
```

### Build iOS
```bash
# Development
flutter build ios -t lib/main_dev.dart

# Production
flutter build ios -t lib/main_prod.dart
```

## Project Structure

```
lib/
├── config/
│   ├── env_config.dart          # Environment configuration interface
│   └── env/
│       ├── dev_config.dart      # Development environment settings
│       └── prod_config.dart     # Production environment settings
├── core/
│   └── theme/
│       ├── app_colors.dart      # Centralized color management
│       ├── app_theme.dart       # Complete theme configuration
│       └── text_styles.dart     # Typography system
├── main.dart                     # Main app (requires env initialization)
├── main_dev.dart                 # Development entry point
└── main_prod.dart                # Production entry point
```

## Customization

### Changing Colors

Edit the respective environment config file:

**Development Colors** (`lib/config/env/dev_config.dart`):
```dart
@override
Color get primaryColor => const Color(0xFF6366F1); // Change this
```

**Production Colors** (`lib/config/env/prod_config.dart`):
```dart
@override
Color get primaryColor => const Color(0xFF14B8A6); // Change this
```

### Changing API URLs

Edit the `apiBaseUrl` in the respective environment config:

```dart
@override
String get apiBaseUrl => 'https://your-api-url.com';
```

### Adding New Environment Variables

1. Add the property to `EnvConfig` interface:
```dart
// lib/config/env_config.dart
abstract class EnvConfig {
  String get yourNewProperty;
}
```

2. Implement it in both `DevConfig` and `ProdConfig`:
```dart
@override
String get yourNewProperty => 'dev-value';
```

3. Access it anywhere in the app:
```dart
EnvConfig.instance.yourNewProperty
```

## Using Environment Config in Code

### Accessing API URL
```dart
import 'package:starter/config/env_config.dart';

final apiUrl = EnvConfig.instance.apiBaseUrl;
```

### Accessing Colors
```dart
import 'package:starter/core/theme/app_colors.dart';

Container(
  color: AppColors.primary, // Automatically uses env-specific color
)
```

### Checking Environment
```dart
if (EnvConfig.instance.isDevelopment) {
  print('Running in development mode');
}
```

## Notes

- **Never run `lib/main.dart` directly** - it requires environment initialization
- Always use `main_dev.dart` or `main_prod.dart` as entry points
- Colors automatically update based on the active environment
- All theme components use the centralized color system
