import 'package:eloit/screens/auth/auth_helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eloit/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  group('auth test', () {
    testWidgets('input email', (WidgetTester tester) async {
      // Build the app.
      app.main();

      // Trigger a frame.
      print("waiting for");
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await binding.takeScreenshot('integration_test/screenshots/screenshot-1');

      final username = find.byKey(const Key("custom_field"));
      // final fields = find.byWidgetPredicate((widget) => widget is EmailField);
      // expect(fields, findsWidgets);
      // expect(fields, findsNothing);
      print(username.toString());
      // debugPrint(username);

      await tester.tap(username);
      await tester.enterText(username, 'hou.d.xinli@gmail.com');
      await tester.pumpAndSettle();
      print("take a screen shot");
      await binding.takeScreenshot('integration_test/screenshots/screenshot-2');

      final password = find.byKey(const Key('password_field'));
      await tester.tap(password);
      await tester.enterText(password, 'test123');
      await tester.pumpAndSettle();
      print("enter password");
      await binding.takeScreenshot('integration_test/screenshots/screenshot-3');

      final button = find.byKey(const Key('sign_in_button'));
      await tester.tap(button);
      await tester.pump(const Duration(seconds: 20));
      print("after login");
      await binding.takeScreenshot('integration_test/screenshots/screenshot-4');
    });
  });
}
