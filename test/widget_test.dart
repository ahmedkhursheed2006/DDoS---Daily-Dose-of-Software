import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_2_ui/main.dart';

void main() {
  testWidgets('Home route loads the shell and Explore tab is visible', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DDoSApp());
    await tester.pumpAndSettle();

    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    final context = tester.element(find.byType(Scaffold));
    Navigator.of(context).pushNamed('/home');
    await tester.pumpAndSettle();

    expect(find.text('Explore'), findsOneWidget);
  });
}
