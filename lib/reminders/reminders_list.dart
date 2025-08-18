import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/change_notifiers/reminder_provider.dart';
import 'package:notesapp/widgets/reminder_card.dart';
import 'package:notesapp/reminders/reminders.dart';
import 'package:notesapp/change_notifiers/reminder_controller.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/widgets/notes_fab.dart';

class RemindersList extends StatefulWidget {
  const RemindersList({super.key});

  @override
  State<RemindersList> createState() => _RemindersListState();
}

class _RemindersListState extends State<RemindersList> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Upcoming',
    'Overdue',
    'Completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          Consumer<ReminderProvider>(
            builder: (context, reminderProvider, child) {
              if (reminderProvider.reminders.isEmpty) {
                return const SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                onSelected: (String value) {
                  setState(() {
                    _selectedFilter = value;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return _filterOptions.map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Row(
                        children: [
                          Icon(
                            _getFilterIcon(option),
                            color: _selectedFilter == option
                                ? primary
                                : gray500,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            option,
                            style: TextStyle(
                              color: _selectedFilter == option
                                  ? primary
                                  : gray500,
                              fontWeight: _selectedFilter == option
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(FontAwesomeIcons.filter, color: primary),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ReminderProvider>(
        builder: (context, reminderProvider, child) {
          List<dynamic> filteredReminders = _getFilteredReminders(
            reminderProvider,
          );

          if (filteredReminders.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              if (_selectedFilter == 'All')
                _buildSummaryCards(reminderProvider),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredReminders.length,
                  itemBuilder: (context, index) {
                    return ReminderCard(reminder: filteredReminders[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: NotesFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => ReminderController(),
                child: const Reminders(isNewReminder: true),
              ),
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredReminders(ReminderProvider provider) {
    switch (_selectedFilter) {
      case 'Upcoming':
        return provider.getUpcomingReminders();
      case 'Overdue':
        return provider.getOverdueReminders();
      case 'Completed':
        return provider.getCompletedReminders();
      default:
        return provider.reminders;
    }
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'All':
        return FontAwesomeIcons.list;
      case 'Upcoming':
        return FontAwesomeIcons.clock;
      case 'Overdue':
        return FontAwesomeIcons.triangleExclamation;
      case 'Completed':
        return FontAwesomeIcons.circleCheck;
      default:
        return FontAwesomeIcons.list;
    }
  }

  Widget _buildSummaryCards(ReminderProvider provider) {
    final upcoming = provider.getUpcomingReminders().length;
    final overdue = provider.getOverdueReminders().length;
    final completed = provider.getCompletedReminders().length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Upcoming',
              upcoming.toString(),
              Colors.blue,
              FontAwesomeIcons.clock,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Overdue',
              overdue.toString(),
              Colors.red,
              FontAwesomeIcons.triangleExclamation,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Completed',
              completed.toString(),
              Colors.green,
              FontAwesomeIcons.circleCheck,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    Color color;

    switch (_selectedFilter) {
      case 'Upcoming':
        message = 'No upcoming reminders';
        icon = FontAwesomeIcons.clock;
        color = Colors.blue;
        break;
      case 'Overdue':
        message = 'No overdue reminders';
        icon = FontAwesomeIcons.triangleExclamation;
        color = Colors.red;
        break;
      case 'Completed':
        message = 'No completed reminders';
        icon = FontAwesomeIcons.circleCheck;
        color = Colors.green;
        break;
      default:
        message = 'No reminders yet';
        icon = FontAwesomeIcons.bell;
        color = gray500;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: color.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: gray500,
              fontFamily: 'Fredoka',
            ),
          ),
        ],
      ),
    );
  }
}
