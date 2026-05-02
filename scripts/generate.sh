#!/bin/bash
# Run Drift and Freezed code generation
flutter pub get
dart run build_runner build --delete-conflicting-outputs
