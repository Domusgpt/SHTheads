import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/tradesman/tradesman_shell.dart';
import 'screens/tradesman/map_screen.dart';
import 'screens/tradesman/feed_screen.dart';
import 'screens/tradesman/profile_screen.dart';
import 'screens/admin/admin_dashboard.dart';

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/login',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isGoingToLogin = state.uri.path == '/login';

        if (!isAuthenticated && !isGoingToLogin) {
          return '/login';
        }

        if (isAuthenticated && isGoingToLogin) {
          if (authProvider.role == UserRole.admin) {
            return '/admin';
          }
          return '/tradesman/map';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboard(),
        ),
        ShellRoute(
          builder: (context, state, child) => TradesmanShell(child: child),
          routes: [
            GoRoute(
              path: '/tradesman/map',
              builder: (context, state) => const MapScreen(),
            ),
            GoRoute(
              path: '/tradesman/feed',
              builder: (context, state) => const FeedScreen(),
            ),
            GoRoute(
              path: '/tradesman/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
