import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/progress_stats.dart';
import '../widgets/streak_banner.dart';
import '../widgets/weekly_activity_chart.dart';
import '../widgets/progress_stat_card.dart';
import '../widgets/skills_mastery_section.dart';
import '../widgets/recent_achievements_section.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late StreakData _streak;
  late ProgressStats _progress;
  late List<SkillProgress> _skills;
  late List<String> _coreStrengths;
  late List<AchievementItem> _achievements;

  @override
  void initState() {
    super.initState();

    _streak = MockHomeRepository.getStreak();
    _progress = MockHomeRepository.getProgress();
    _skills = MockHomeRepository.getSkillsMastery();
    _coreStrengths = MockHomeRepository.getCoreStrengths();
    _achievements = MockHomeRepository.getRecentAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
              children: [
                // -------------------------------------------------
                // HEADER
                // -------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.menu,
                          size: 24,
                          color: AppColors.textPrimary,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'DDoS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryOrangeDark,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.accentPeach,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_fire_department_outlined,
                        color: AppColors.primaryOrange,
                        size: 21,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // -------------------------------------------------
                // TITLE
                // -------------------------------------------------
                const Text('My Progress', style: AppTextStyles.heading1),

                const SizedBox(height: 4),

                const Text(
                  'Track your evolution through the curriculum.',
                  style: AppTextStyles.caption,
                ),

                const SizedBox(height: 18),

                // -------------------------------------------------
                // STREAK
                // -------------------------------------------------
                StreakBanner(streakDays: _streak.currentStreakDays),

                const SizedBox(height: 16),

                // -------------------------------------------------
                // STATS
                // -------------------------------------------------
                ProgressStatsGrid(
                  conceptsMastered: _progress.conceptsMastered,
                  blueprintsFinished: _progress.blueprintsFinished,
                  hoursLearned: _progress.hoursLearned,
                  accuracyPercent: _progress.accuracyPercent,
                ),

                const SizedBox(height: 16),

                // -------------------------------------------------
                // WEEKLY ACTIVITY
                // -------------------------------------------------
                WeeklyActivityChart(weekActivity: _streak.weekActivity),

                const SizedBox(height: 16),

                // -------------------------------------------------
                // SKILLS
                // -------------------------------------------------
                SkillsMasterySection(
                  skills: _skills,
                  coreStrengths: _coreStrengths,
                ),

                const SizedBox(height: 20),

                // -------------------------------------------------
                // ACHIEVEMENTS
                // -------------------------------------------------
                RecentAchievementsSection(achievements: _achievements),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
