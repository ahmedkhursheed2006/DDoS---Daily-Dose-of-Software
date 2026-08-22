// task10_demo_screen.dart
// Standalone screen wiring together: search bar + category filters
// + daily reminder widget, using mock data. Drop this screen into
// the app's navigation (or run main.dart) to preview Task 10 in
// isolation, independent of backend/auth work.

import 'package:flutter/material.dart';
import '../models/mock_data.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_filters.dart';
import '../widgets/daily_reminder_widget.dart';

class Task10DemoScreen extends StatefulWidget {
  const Task10DemoScreen({super.key});

  @override
  State<Task10DemoScreen> createState() => _Task10DemoScreenState();
}

class _Task10DemoScreenState extends State<Task10DemoScreen> {
  List<Lesson> _allLessons = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _query = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final lessons = await fetchLessons();
    final categories = await fetchCategories();
    setState(() {
      _allLessons = lessons;
      _categories = categories;
      _loading = false;
    });
  }

  List<Lesson> get _filteredLessons {
    return _allLessons.where((lesson) {
      final matchesCategory =
          _selectedCategory == 'All' || lesson.category == _selectedCategory;
      final matchesQuery = _query.isEmpty ||
          lesson.title.toLowerCase().contains(_query.toLowerCase()) ||
          lesson.summary.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: AppSearchBar(
                      onQueryChanged: (q) => setState(() => _query = q),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategoryFilters(
                      categories: _categories,
                      selected: _selectedCategory,
                      onSelected: (c) => setState(() => _selectedCategory = c),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: DailyReminderWidget(
                      onChanged: (settings) {
                        // Wire to flutter_local_notifications later.
                        debugPrint(
                            'Reminder updated: enabled=${settings.enabled}, time=${settings.time}');
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _filteredLessons.isEmpty
                        ? const Center(child: Text('No lessons match your search.'))
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: _filteredLessons.length,
                            itemBuilder: (context, index) {
                              final lesson = _filteredLessons[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                child: ListTile(
                                  title: Text(lesson.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  subtitle: Text(lesson.summary),
                                  trailing: Chip(
                                    label: Text(lesson.category),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
