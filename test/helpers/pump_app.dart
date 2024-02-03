import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/presentation/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(String initialRoute) {
    return pumpWidget(
      MaterialApp.router(
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: goRouter(initialRoute),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
      ),
    );
  }
}
