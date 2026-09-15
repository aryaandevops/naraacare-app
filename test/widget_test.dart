import 'package:flutter_test/flutter_test.dart';
import 'package:naara_care_app/main.dart';

void main() {
testWidgets('app launches to splash screen', (WidgetTester tester) async {
await tester.pumpWidget(const MyApp());

```
await tester.pump();

await tester.pump(const Duration(seconds: 4));

await tester.pump();
```

});
}
