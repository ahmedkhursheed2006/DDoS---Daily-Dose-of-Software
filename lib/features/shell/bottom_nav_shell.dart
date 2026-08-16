import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../home/screens/home_screen.dart';
import '../home/screens/progress_screen.dart';
import '../placeholder/coming_soon_screen.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),

    const ComingSoonScreen(title: 'Explore', icon: Icons.explore_outlined),

    const ComingSoonScreen(
      title: 'Daily Dose',
      icon: Icons.local_fire_department_outlined,
    ),

    const ProgressScreen(),

    const ComingSoonScreen(title: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        backgroundColor: AppColors.cardBackground,

        selectedItemColor: AppColors.primaryOrange,

        unselectedItemColor: AppColors.textSecondary,

        showUnselectedLabels: true,

        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),

        unselectedLabelStyle: const TextStyle(fontSize: 11),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_outlined),
            activeIcon: Icon(Icons.local_fire_department),
            label: 'Daily Dose',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
