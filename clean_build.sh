#! /bin/bash

flutter clean 
flutter pub get
clear
# flutter build appbundle --flavor development --target lib/main_development.dart
# flutter build appbundle --flavor staging --target lib/main_staging.dart
# flutter build apk --debug --flavor production --target lib/main_production.dart
flutter build apk --flavor production --target lib/main_production.dart
# flutter build appbundle --flavor production --target lib/main_production.dart
# flutter build appbundle --flavor development --target lib/main_development.dart