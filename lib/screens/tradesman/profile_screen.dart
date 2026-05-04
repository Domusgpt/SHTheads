import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';
import '../../widgets/knife_transition.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, this data comes from Firestore via AuthProvider
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const KnifeTransition(
            initialOffset: -100,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.metallicLight,
              child: Icon(Icons.person, size: 80, color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          KnifeTransition(
            delay: const Duration(milliseconds: 100),
            initialOffset: 100,
            child: Column(
              children: const [
                Text(
                  'Sparky Dan',
                  style: TextStyle(color: AppTheme.accentOrange, fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Master Electrician',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          KnifeTransition(
            delay: const Duration(milliseconds: 200),
            initialOffset: 150,
            child: ReactiveTile(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('Reviews', '14'),
                    _buildStatColumn('Upvotes', '128'),
                    _buildStatColumn('Flags', '0', color: Colors.green),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          KnifeTransition(
            delay: const Duration(milliseconds: 300),
            initialOffset: 200,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.settings),
              label: const Text('Settings & Preferences'),
              onPressed: () {
                // Settings coming soon
              },
            ),
          ),
          const SizedBox(height: 16),
          KnifeTransition(
            delay: const Duration(milliseconds: 400),
            initialOffset: 200,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () => context.read<AuthProvider>().signOut(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {Color color = AppTheme.textPrimary}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
      ],
    );
  }
}
