import 'package:chat_app/domain/value_objects/app_constants.dart';
import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/presentation/router/router.dart';
import 'package:chat_app/presentation/router/routes.dart';
import 'package:chat_app/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.dark(),
      darkTheme: AppTheme.dark(),
      title: appName,
      routerConfig: goRouter(Routes.loginPagePath),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
    );
  }
}
