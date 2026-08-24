import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../search_bar_widget.dart';

void main() {
  testWidgets('Task 10 search bar renders and accepts input', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppSearchBar(onQueryChanged: _noop),
        ),
      ),
    );
    expect(find.text('Search lessons, topics, series...'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'pointers');
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('pointers'), findsOneWidget);
  });
}

void _noop(String _) {}
