import 'package:chat_app/domain/value_objects/app_constants.dart';
import 'package:chat_app/presentation/chat/chat_page.dart';
import 'package:chat_app/presentation/login/login_page.dart';
import 'package:chat_app/presentation/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter([String? initialLocation]) => GoRouter(
      initialLocation: initialLocation ?? Routes.loginPagePath,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      redirect: (BuildContext context, GoRouterState state) {
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          name: Routes.loginPageRoute,
          path: Routes.loginPagePath,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (
              __,
              Animation<double> animation,
              _,
              Widget child,
            ) =>
                FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          name: Routes.chatPageRoute,
          path: Routes.chatPagePath,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              CustomTransitionPage<void>(
            key: state.pageKey,
            child: ChatPage(
              userIdentifier: (state.extra as String?) ?? userId,
            ),
            transitionsBuilder: (
              __,
              Animation<double> animation,
              _,
              Widget child,
            ) =>
                FadeTransition(opacity: animation, child: child),
          ),
        ),
      ],
    );
