# Stores App

A Flutter application for browsing stores and products, with user authentication and profile management.

## Features

- User authentication (signup, login, logout)
- Browse stores and products
- View store details and products
- Search for stores and items
- User profile management (view, update, upload profile picture)
- Map and directions to stores

## Project Structure

```
lib/
  main.dart
  external/
    app_data.dart
    database/
    model/
    theme/
    widget/
  main/
    provider/
    services/
    view/
  splash/
  store_details/
  user/
    controller/
    provider/
    repo/
    views/
assets/
  logo.png
  images/
android/
ios/
web/
test/
```

## Getting Started

1. **Install dependencies:**
   ```sh
   flutter pub get
   ```

2. **Run the app:**
   ```sh
   flutter run
   ```

3. **Build for web:**
   ```sh
   flutter build web
   ```

## Configuration

- The backend server URL is set in [`AppData.SERVER_URL`](lib/external/app_data.dart).
- You can change the server URL on the splash screen if needed.

## Packages Used

- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [http](https://pub.dev/packages/http)
- [top_snackbar_flutter](https://pub.dev/packages/top_snackbar_flutter)
- [faker](https://pub.dev/packages/faker)
- [image_picker](https://pub.dev/packages/image_picker)
- [loading_indicator](https://pub.dev/packages/loading_indicator)

## Folder Overview

- `lib/main.dart`: App entry point.
- `lib/external/`: Shared models, themes, widgets, and app data.
- `lib/main/`: Main app views, providers, and services.
- `lib/user/`: User authentication, profile, and related logic.
- `lib/splash/`: Splash screen and initial data loading.
- `lib/store_details/`: Store detail views and providers.
