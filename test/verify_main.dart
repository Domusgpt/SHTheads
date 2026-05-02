import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shtheads/main.dart';
import 'package:shtheads/providers/auth_provider.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const SHTheadsApp(),
      ),
    );
    expect(find.text('SHTheads'), findsWidgets);
  });
}
