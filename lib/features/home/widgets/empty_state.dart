import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FeedEmptyState extends StatelessWidget {
  final VoidCallback onExplore;
  const FeedEmptyState({super.key, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.accentPeach,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.explore_outlined,
              color: AppColors.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          const Text('No series followed yet', style: AppTextStyles.heading2),
          const SizedBox(height: 6),
          const Text(
            "Follow a few topics on Explore and today's posts will show up here.",
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: onExplore,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text('Go to Explore'),
          ),
        ],
      ),
    );
  }
}
