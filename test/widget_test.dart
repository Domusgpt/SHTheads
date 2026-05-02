import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shtheads/main.dart';

void main() {
  testWidgets('App starts up', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SHTheadsApp());

    expect(find.text('SHTheads'), findsWidgets);
  });
}
