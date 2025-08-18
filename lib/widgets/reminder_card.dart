import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/model/reminder.dart';
import 'package:notesapp/colors.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/change_notifiers/reminder_provider.dart';
import 'package:notesapp/change_notifiers/reminder_controller.dart';
import 'package:notesapp/reminders/reminders.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final VoidCallback? onTap;

  const ReminderCard({super.key, required this.reminder, this.onTap});

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final reminderDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateText;
    if (reminderDate == today) {
      dateText = 'Today';
    } else if (reminderDate == tomorrow) {
      dateText = 'Tomorrow';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      dateText =
          '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    }

    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final timeText =
        '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';

    return '$dateText at $timeText';
  }

  Color _getCategoryColor() {
    switch (reminder.category.toLowerCase()) {
      case 'work':
        return Colors.blue;
      case 'personal':
        return Colors.green;
      case 'other':
        return Colors.orange;
      default:
        return gray700;
    }
  }

  IconData _getCategoryIcon() {
    switch (reminder.category.toLowerCase()) {
      case 'work':
        return FontAwesomeIcons.briefcase;
      case 'personal':
        return FontAwesomeIcons.user;
      case 'other':
        return FontAwesomeIcons.star;
      default:
        return FontAwesomeIcons.bell;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        !reminder.isCompleted && reminder.dateTime.isBefore(DateTime.now());

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: isOverdue ? Colors.red : primary, width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isOverdue ? Colors.red : primary).withValues(alpha: 0.3),
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap:
            onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) =>
                        ReminderController()..reminder = reminder,
                    child: const Reminders(isNewReminder: false),
                  ),
                ),
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      _getCategoryIcon(),
                      color: _getCategoryColor(),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: reminder.isCompleted ? gray300 : gray900,
                            decoration: reminder.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reminder.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getCategoryColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (isOverdue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.triangleExclamation,
                                size: 10,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Overdue',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ReminderProvider>()
                              .toggleReminderCompletion(reminder);
                        },
                        child: FaIcon(
                          reminder.isCompleted
                              ? FontAwesomeIcons.circleCheck
                              : FontAwesomeIcons.circle,
                          color: reminder.isCompleted ? Colors.green : gray300,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (reminder.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  reminder.description,
                  style: TextStyle(
                    color: reminder.isCompleted ? gray300 : gray900,
                    decoration: reminder.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.clock,
                    size: 14,
                    color: isOverdue ? Colors.red : gray500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDateTime(reminder.dateTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: isOverdue ? Colors.red : gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _showDeleteDialog(context);
                    },
                    child: FaIcon(
                      FontAwesomeIcons.trash,
                      size: 12,
                      color: gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Reminder'),
          content: Text('Are you sure you want to delete "${reminder.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ReminderProvider>().deleteReminder(reminder);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
