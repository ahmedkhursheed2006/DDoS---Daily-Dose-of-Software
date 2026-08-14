import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/bottom_nav_shell.dart';

void main() {
  runApp(const DDoSApp());
}

class DDoSApp extends StatelessWidget {
  const DDoSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DDoS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const BottomNavShell(),
    );
  }
}
