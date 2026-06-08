import 'package:flutter_test/flutter_test.dart';

import 'package:universal_rating_bar_example/main.dart';

void main() {
  testWidgets('Example app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Universal Rating Bar'), findsOneWidget);
    expect(find.text('Current rating'), findsOneWidget);
  });
}
