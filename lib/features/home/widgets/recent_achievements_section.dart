import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

class RecentAchievementsSection extends StatelessWidget {
  final List<AchievementItem> achievements;

  const RecentAchievementsSection({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recent Achievements', style: AppTextStyles.heading1),

        const SizedBox(height: 12),

        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: achievements.length,
            separatorBuilder: (_, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final achievement = achievements[index];

              return _AchievementCard(achievement: achievement, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final AchievementItem achievement;
  final int index;

  const _AchievementCard({required this.achievement, required this.index});

  IconData get _icon {
    if (index == 0) {
      return Icons.emoji_events_outlined;
    }

    if (index == 1) {
      return Icons.star_outline;
    }

    return Icons.workspace_premium_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.accentPeach,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(_icon, color: AppColors.primaryOrange, size: 27),
          ),

          const SizedBox(height: 12),

          Text(
            achievement.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 5),

          Text(
            achievement.description,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
