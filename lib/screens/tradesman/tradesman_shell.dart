import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class TradesmanShell extends StatelessWidget {
  final Widget child;
  const TradesmanShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine the current index based on the GoRouter location
    final String location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.startsWith('/tradesman/map')) {
      currentIndex = 0;
    } else if (location.startsWith('/tradesman/feed')) {
      currentIndex = 1;
    } else if (location.startsWith('/tradesman/profile')) {
      currentIndex = 2;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('SHTheads', style: TextStyle(color: AppTheme.accentOrange)),
        centerTitle: true,
      ),
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: const Border(top: BorderSide(color: AppTheme.metallicLight, width: 2)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.darkSurface,
          selectedItemColor: AppTheme.accentOrange,
          unselectedItemColor: AppTheme.textSecondary,
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 0) {
              context.go('/tradesman/map');
            } else if (index == 1) {
              context.go('/tradesman/feed');
            } else if (index == 2) {
              context.go('/tradesman/profile');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
