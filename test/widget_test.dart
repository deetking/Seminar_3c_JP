import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dice_roller/main.dart';

void main() {
  testWidgets('app shows a dice and can roll it', (WidgetTester tester) async {
    await tester.pumpWidget(const DiceApp());

    expect(find.text('Hod kockou'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.tap(find.text('Hodiť'));
    await tester.pump();

    expect(find.text('Hádžem...'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Hodiť'), findsOneWidget);
  });
}
