import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/auth_provider.dart';
import 'providers/filter_provider.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'widgets/crt_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDOCAbC123dEf456GhI789jKl01-MnO", // Mock/Stub API key for now
      appId: "1:108242257530:web:123abc456def",
      messagingSenderId: "108242257530",
      projectId: "hemoc-487722",
      authDomain: "hemoc-487722.firebaseapp.com",
      storageBucket: "hemoc-487722.appspot.com",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
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
