import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class WeeklyActivityChart extends StatelessWidget {
  final List<bool> weekActivity;

  const WeeklyActivityChart({super.key, required this.weekActivity});

  static const List<String> _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 165,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weekly Activity', style: AppTextStyles.heading2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Activity', style: AppTextStyles.caption),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Weekly bars
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final bool active =
                    index < weekActivity.length && weekActivity[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 22,
                      height: 60,
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primaryOrange
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(_labels[index], style: AppTextStyles.caption),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
