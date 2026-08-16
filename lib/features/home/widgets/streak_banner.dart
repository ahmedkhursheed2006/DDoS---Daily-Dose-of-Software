import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class StreakBanner extends StatelessWidget {
  final int streakDays;
  const StreakBanner({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
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
            decoration: const BoxDecoration(
              color: AppColors.accentPeach,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.primaryOrange,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$streakDays Day Streak',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading1.copyWith(
              fontSize: 24,
              color: AppColors.primaryOrangeDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "You're in the flow. Keep the momentum going to solidify your software architectural foundations.",
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (i) {
              final active = i < (streakDays % 7 == 0 ? 7 : streakDays % 7);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primaryOrange : AppColors.divider,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
