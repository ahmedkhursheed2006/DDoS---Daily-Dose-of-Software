import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/offline_provider.dart';
import 'services/notification_service.dart';
import 'utils/constants.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification system
  await NotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => OfflineProvider()),
      ],
      child: const DDoSApp(),
    ),
  );
}

class DDoSApp extends StatelessWidget {
  const DDoSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DDoS - Daily Dose of Software',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryTheme,
          primary: AppConstants.primaryColor,
        ),
        scaffoldBackgroundColor: AppConstants.backgroundColor,
      ),
      home: const SplashScreen(),
    );
  }
}
