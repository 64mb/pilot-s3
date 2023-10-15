import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilot_s3/widgets/path_chips/path_chips.dart';

void main() {
  testWidgets('Renders passed text to chips', (tester) async {
    const String testText = 'Chips label';
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PathChips(
          label: testText,
          onTap: () {},
        ),
      ),
    ));

    final labelFinder = find.text(testText);
    expect(labelFinder, findsOneWidget);
  });

  testWidgets('Change chips color after hover', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PathChips(
          onTap: () {},
        ),
      ),
    ));
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is Container && widget.color == Colors.grey[150]),
        findsOneWidget);

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.byType(PathChips)));
    await tester.pumpAndSettle();

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is Container && widget.color == Colors.grey[170]),
        findsOneWidget);
  });
}
