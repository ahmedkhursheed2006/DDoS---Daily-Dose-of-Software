import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const ProgressStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryOrange, size: 20),

          const SizedBox(height: 8),

          Text(value, style: AppTextStyles.statNumber),

          const SizedBox(height: 3),

          Text(
            label,
            style: AppTextStyles.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class ProgressStatsGrid extends StatelessWidget {
  final int conceptsMastered;
  final int blueprintsFinished;
  final double hoursLearned;
  final double accuracyPercent;

  const ProgressStatsGrid({
    super.key,
    required this.conceptsMastered,
    required this.blueprintsFinished,
    required this.hoursLearned,
    required this.accuracyPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProgressStatCard(
                icon: Icons.school_outlined,
                value: '$conceptsMastered',
                label: 'CONCEPTS\nMASTERED',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ProgressStatCard(
                icon: Icons.architecture_outlined,
                value: '$blueprintsFinished',
                label: 'BLUEPRINTS\nFINISHED',
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProgressStatCard(
                icon: Icons.schedule_outlined,
                value: '${hoursLearned.toStringAsFixed(1)}h',
                label: 'HOURS\nLEARNED',
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ProgressStatCard(
                icon: Icons.track_changes_outlined,
                value: '${accuracyPercent.toStringAsFixed(0)}%',
                label: 'ACCURACY',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
