import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/reactive_tile.dart';
import '../../widgets/knife_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);

    // Call the AuthProvider to handle the sign in
    await context.read<AuthProvider>().signIn(
      _emailController.text,
      _passwordController.text,
    );

    // Note: GoRouter listens to AuthProvider, so it will automatically redirect
    // us to the correct portal once authentication state changes.
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: KnifeTransition(
          initialOffset: 200.0,
          child: ReactiveTile(
            width: 350,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'SHTheads',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.accentOrange,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tradesman Portal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppTheme.textSecondary),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: AppTheme.textSecondary),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.metallicLight)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme.accentOrange)),
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
