import 'package:chat_app/presentation/router/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpApp(Routes.loginPagePath);

      final Finder continueButton = find.text('Continue');
      final Finder continueAsGuestButton = find.text('Continue as Guest');

      expect(continueButton, findsOneWidget);
      expect(continueAsGuestButton, findsOneWidget);
    });
  });
}
