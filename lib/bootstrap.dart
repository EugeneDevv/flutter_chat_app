// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/value_objects/app_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sendbird_chat_sdk/sendbird_chat_sdk.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load();

      try {
        final String sendBirdAppId = dotenv.env['SENDBIRD_APP_ID'] ?? '';

        await SendbirdChat.init(appId: sendBirdAppId);
        // SendbirdChat.addUserEventHandler('Eugene123', handler);

        final User user = await SendbirdChat.connect('Eujoh123');

        print(user);

        final OpenChannel openChannel = await OpenChannel.getChannel(
          channelUrl,
        );
        // Call the instance method of the result object in the openChannel parameter of the callback method.
        await openChannel.enter();
        // The current user successfully enters the open channel as a participant,
        // and can chat with other users in the channel using APIs.
        print(openChannel.data);
      } catch (e) {
        // Handle error.
        print(e);
      }
      runApp(await builder());
    },
    (Object error, StackTrace stackTrace) =>
        log(error.toString(), stackTrace: stackTrace),
  );
}
