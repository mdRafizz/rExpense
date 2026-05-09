# rExpense

A high-end, minimalist expense tracker built with Flutter. rExpense helps you manage your personal finances with a clean UI, powerful analytics, and seamless cloud backup via Google Drive.

## Features

- **Expense Tracking** — Log and manage transactions with custom categories
- **Analytics** — Visualize spending patterns with interactive charts
- **Google Drive Sync** — Automatic cloud backup and restore via OAuth2
- **Multi-member Support** — Track expenses across multiple members
- **Dark & Light Theme** — Follows system appearance with a polished Material 3 design
- **Offline-first** — Local SQLite database powered by Drift, works without internet

## Tech Stack

| Layer | Technology |
|---|---|
| UI | Flutter, fl_chart, Material 3 |
| State Management | flutter_bloc / Cubit |
| Local Database | Drift (SQLite) |
| Cloud Sync | Google Drive API + OAuth2 |
| Navigation | go_router |
| Dependency Injection | get_it |
| Code Generation | freezed, json_serializable, drift_dev |

## Architecture

The project follows a clean architecture pattern with four layers:

- `domain` — Entities, repository interfaces, and use cases
- `data` — Repository implementations, local database, and mappers
- `application` — BLoC/Cubit state management
- `presentation` — Screens and widgets

## Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/mdRafizz/rExpense.git
   cd rexpense
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run code generation**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

> Requires Flutter SDK `^3.5.0` and a configured `google-services.json` for Firebase.
