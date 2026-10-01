import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quotes_app/widgets/error_view.dart';

void main() {
  testWidgets('ErrorView shows the message and calls onRetry', (tester) async {
    var retries = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView(message: 'Oops', onRetry: () => retries++),
        ),
      ),
    );

    expect(find.text('Oops'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    expect(retries, 1);
  });

  testWidgets('ErrorView hides Retry when there is no callback', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ErrorView(message: 'Oops'))),
    );

    expect(find.text('Retry'), findsNothing);
  });
}
