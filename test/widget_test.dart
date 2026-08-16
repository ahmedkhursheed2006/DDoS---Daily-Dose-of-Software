import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:task_2_ui/main.dart';

void main() {
  testWidgets('Home screen loads with streak banner', (
    WidgetTester tester,
  ) async {
    // Make the test surface tall enough so the whole scrollable
    // Home Dashboard (streak banner + progress grid + weekly chart)
    // actually gets built, not just what fits in the default 800x600.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DDoSApp());
    await tester.pumpAndSettle();

    expect(find.text('My Progress'), findsOneWidget);
    expect(find.textContaining('Day Streak'), findsOneWidget);
    expect(find.text('Weekly Activity'), findsOneWidget);
  });
}
