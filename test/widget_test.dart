import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:shtheads/main.dart';
import 'package:shtheads/providers/auth_provider.dart';

void main() {
  testWidgets('App starts up', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const SHTheadsApp(),
      ),
    );

    // Initial route is /login, we should see the login screen title
    expect(find.text('Tradesman Portal'), findsWidgets);
  });
}
