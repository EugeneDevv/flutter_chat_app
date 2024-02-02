import 'package:chat_app/presentation/chat_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/presentation/app.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(ChatPage), findsOneWidget);
    });
  });
}
