// daily_reminder_widget.dart
// UI for setting a daily learning reminder: on/off toggle + time picker.
//
// NOTE FOR INTEGRATION (Task 9 / backend hookup):
// This widget currently only keeps state locally via `onChanged`.
// To make it actually notify the user, add the `flutter_local_notifications`
// package and call `scheduleDailyReminder(time)` from the `onChanged`
// callback in the parent screen — this widget doesn't need to change.
// Example call site is commented at the bottom of this file.

import 'package:flutter/material.dart';

class ReminderSettings {
  final bool enabled;
  final TimeOfDay time;

  const ReminderSettings({required this.enabled, required this.time});

  ReminderSettings copyWith({bool? enabled, TimeOfDay? time}) {
    return ReminderSettings(
      enabled: enabled ?? this.enabled,
      time: time ?? this.time,
    );
  }
}

class DailyReminderWidget extends StatefulWidget {
  final ReminderSettings initialSettings;
  final ValueChanged<ReminderSettings> onChanged;

  const DailyReminderWidget({
    super.key,
    this.initialSettings =
        const ReminderSettings(enabled: true, time: TimeOfDay(hour: 19, minute: 0)),
    required this.onChanged,
  });

  @override
  State<DailyReminderWidget> createState() => _DailyReminderWidgetState();
}

class _DailyReminderWidgetState extends State<DailyReminderWidget> {
  late ReminderSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _settings.time,
    );
    if (picked != null) {
      setState(() => _settings = _settings.copyWith(time: picked));
      widget.onChanged(_settings);
    }
  }

  void _toggle(bool value) {
    setState(() => _settings = _settings.copyWith(enabled: value));
    widget.onChanged(_settings);
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              child: const Icon(Icons.notifications_active_outlined),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Learning Reminder',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: _settings.enabled ? _pickTime : null,
                    child: Text(
                      _settings.enabled
                          ? 'Every day at ${_formatTime(_settings.time)}'
                          : 'Reminders off',
                      style: TextStyle(
                        color: _settings.enabled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).disabledColor,
                        fontSize: 13,
                        decoration: _settings.enabled
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: _settings.enabled, onChanged: _toggle),
          ],
        ),
      ),
    );
  }
}

/* ---------------- Example integration (do NOT uncomment until
   flutter_local_notifications is added to pubspec.yaml) ----------------

DailyReminderWidget(
  onChanged: (settings) {
    if (settings.enabled) {
      scheduleDailyReminder(settings.time); // your notification helper
    } else {
      cancelDailyReminder();
    }
  },
)

------------------------------------------------------------------------- */
