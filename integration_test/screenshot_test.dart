import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eloit/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
      as IntegrationTestWidgetsFlutterBinding;

  testWidgets('screenshot', (WidgetTester tester) async {
    // Build the app.
    app.main();

    // Trigger a frame.
    print("waiting for");
    await tester.pumpAndSettle(const Duration(seconds: 2));
    print("take a screen shot");
    await binding.takeScreenshot('screenshot-1');
  });
}
