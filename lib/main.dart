import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'widgets/crt_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const SHTheadsApp(),
    ),
  );
}

class SHTheadsApp extends StatelessWidget {
  const SHTheadsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final router = AppRouter.createRouter(authProvider);

    return MaterialApp.router(
      title: 'SHTheads',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        // Wrap the entire app in the CRT effect
        if (child == null) return const SizedBox.shrink();

        // Import must be added at top
        return _CrtAppWrapper(child: child);
      },
    );
  }
}

class _CrtAppWrapper extends StatelessWidget {
  final Widget child;
  const _CrtAppWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return CrtWrapper(child: child);
  }
}
