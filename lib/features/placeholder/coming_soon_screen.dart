import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  const ComingSoonScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.accentPeach,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: AppColors.primaryOrange, size: 30),
              ),
              const SizedBox(height: 16),
              Text(title, style: AppTextStyles.heading1),
              const SizedBox(height: 6),
              const Text(
                'Coming soon — built by another team task.',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
