import 'package:flutter_test/flutter_test.dart';

import 'package:safezone_ai/main.dart';

void main() {
  testWidgets('SafeZone AI app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SafeZoneAI());

    expect(find.text('SafeZone AI'), findsOneWidget);
  });
}