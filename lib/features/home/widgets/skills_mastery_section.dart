import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';

class SkillsMasterySection extends StatelessWidget {
  final List<SkillProgress> skills;
  final List<String> coreStrengths;

  const SkillsMasterySection({
    super.key,
    required this.skills,
    required this.coreStrengths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skills Mastery', style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          for (final skill in skills) ...[
            _SkillBar(skill: skill),
            const SizedBox(height: 14),
          ],
          const SizedBox(height: 4),
          const Text('CORE STRENGTHS', style: AppTextStyles.caption),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: coreStrengths
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentPeach,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryOrangeDark,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final SkillProgress skill;
  const _SkillBar({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(skill.name, style: AppTextStyles.body),
            Text('${skill.percent}%', style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: skill.percent / 100,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }
}
