# AeroMel

AeroMel is a Flutter mobile application for monitoring and controlling melon aeroponic greenhouse operations. The app provides a clean operator dashboard for sensor telemetry, nutrient recommendations, misting control, historical analytics, alerts, and device status.

## Features

- Responsive authentication screen with password visibility toggle.
- Greenhouse selection with connectivity and growth-stage status.
- Real-time-ready dashboard for EC, pH, air temperature, humidity, water temperature, and water level.
- Nutrient insight screen with recommendation details and acknowledgement flow.
- Smart misting control with automatic/manual modes, confirmation dialog, command state, and emergency stop.
- History and analytics view with metric summaries and charts.
- Alert center, device overview, and profile/settings screen.
- Floating 5-item bottom navigation optimized for mobile layouts.

## Tech Stack

- Flutter
- Dart
- Material 3
- Riverpod
- GoRouter
- Dio
- WebSocket Channel
- fl_chart
- flutter_secure_storage
- shared_preferences
- lucide_icons
- Google Fonts

## Getting Started

### Prerequisites

- Flutter SDK 3.41 or newer
- Dart 3.11 or newer
- Android Studio or a configured Android SDK

### Install Dependencies

```bash
flutter pub get
```

### Run the App

```bash
flutter run
```

For web preview:

```bash
flutter run -d web-server --web-hostname 127.0.0.1 --web-port 5201
```

Then open:

```text
http://127.0.0.1:5201
```

## Demo Login

```text
Email: operator@aeromel.id
Password: password123
```

## Quality Checks

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

## Build

Build Android debug APK:

```bash
flutter build apk --debug
```

Build web release:

```bash
flutter build web --no-wasm-dry-run
```

## Project Status

The current version is an MVP UI implementation with demo data and integration-ready network foundations. API, authentication persistence, live WebSocket telemetry, and production command acknowledgement can be connected through the existing Dio, secure storage, and WebSocket layers.
