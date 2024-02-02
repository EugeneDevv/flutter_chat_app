import 'package:chat_app/l10n/l10n.dart';
import 'package:chat_app/presentation/chat_page.dart';
import 'package:chat_app/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ChatPage(),
    );
  }
}
