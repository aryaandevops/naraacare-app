```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:naara_care_app/main.dart';

void main() {
  testWidgets('app launches to splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Render the initial splash screen.
    await tester.pump();

    // Let the 4-second splash timer complete.
    await tester.pump(const Duration(seconds: 4));

    // Process the navigation/rebuild.
    await tester.pump();
  });
}
```
