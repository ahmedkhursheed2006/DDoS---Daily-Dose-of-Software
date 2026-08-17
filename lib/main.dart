import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/bottom_nav_shell.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'services/dio_client.dart';

void main() {
  runApp(const DDoSApp());
}

class DDoSApp extends StatelessWidget {
  const DDoSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DDoS',
      navigatorKey: DioClient.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const BottomNavShell(initialIndex: 0),
        '/explore': (context) => const BottomNavShell(initialIndex: 1),
        '/daily-dose': (context) => const BottomNavShell(initialIndex: 2),
        '/progress': (context) => const BottomNavShell(initialIndex: 3),
        '/profile': (context) => const BottomNavShell(initialIndex: 4),
      },
    );
  }
}
