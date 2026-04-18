import 'package:flutter_test/flutter_test.dart';
import 'package:testflutter/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GabesSentinelApp());
    await tester.pumpAndSettle();

    // Verify that the login screen renders
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
