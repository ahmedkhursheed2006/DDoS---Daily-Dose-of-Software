import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final id = await AuthService.getUserId();
    setState(() {
      _userId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundCanvas,
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: AppConstants.cardSurface,
        foregroundColor: AppConstants.primaryText,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.deleteToken();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 80),
              const SizedBox(height: 24),
              const Text(
                'Welcome to DDoS!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _userId != null ? 'Logged in User ID: $_userId' : 'Daily Dose of Software',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppConstants.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
