import 'package:flutter_test/flutter_test.dart';
import 'package:naara_care_app/main.dart';

void main() {
  testWidgets('app launches to splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Let the initial frame render.
    await tester.pump();

    // Allow the 4-second splash timer to complete.
    await tester.pump(const Duration(seconds: 4));

    // Render the resulting screen.
    await tester.pump();
  });
}
