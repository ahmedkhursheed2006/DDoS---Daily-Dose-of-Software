import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

class ContinueLearningCard extends StatelessWidget {
  final ContinueLearningItem item;
  final VoidCallback onResume;
  const ContinueLearningCard({
    super.key,
    required this.item,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onResume,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 168,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.accentPeach,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.menu_book_outlined,
                    size: 15,
                    color: AppColors.primaryOrange,
                  ),
                ),
                Text(
                  '${item.progressPercent}% done',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primaryOrange,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: AppTextStyles.heading2.copyWith(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: item.progressPercent / 100,
                minHeight: 5,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryOrange,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: AppTextStyles.caption.copyWith(fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
