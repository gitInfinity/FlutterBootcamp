import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/widgets/outlined_icon_button.dart';
import 'package:notesapp/colors.dart';
import 'package:provider/provider.dart';
import 'package:notesapp/change_notifiers/reminder_controller.dart';
import 'custom_time_picker.dart';

class Reminders extends StatefulWidget {
  const Reminders({super.key, required this.isNewReminder});
  final bool isNewReminder;

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  late final FocusNode _focusNode;
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isNewReminder) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showTimePicker() {
    final controller = context.read<ReminderController>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomTimePickerDialog(
          initialTime: controller.selectedTime ?? TimeOfDay.now(),
          onTimeSelected: (TimeOfDay time) {
            controller.selectedTime = time;
          },
        );
      },
    );
  }

  void _showDatePicker() async {
    final controller = context.read<ReminderController>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: gray700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: gray700,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != controller.selectedDate) {
      controller.selectedDate = picked;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) {
      return 'Today';
    } else if (selectedDate == tomorrow) {
      return 'Tomorrow';
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
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderController>(
      builder: (context, controller, child) {
        if (!widget.isNewReminder) {
          if (_titleController.text.isEmpty && controller.title.isNotEmpty) {
            _titleController.text = controller.title;
          }
          if (_descriptionController.text.isEmpty &&
              controller.description.isNotEmpty) {
            _descriptionController.text = controller.description;
          }
        }
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            Navigator.pop(context);
          },
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(6.0),
                child: NoteIconButtonOutlined(
                  icon: FontAwesomeIcons.chevronLeft,
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
              ),
              title: Text(
                widget.isNewReminder ? 'Add Reminder' : 'Edit Reminder',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _titleController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title here',
                          hintStyle: TextStyle(color: gray300),
                        ),
                        onChanged: (value) {
                          if (controller.title != value) {
                            controller.title = value;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _descriptionController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Description here',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: gray300),
                        ),
                        onChanged: (value) {
                          if (controller.description != value) {
                            controller.description = value;
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DropdownButton<String>(
                        value: controller.category,
                        icon: const Icon(Icons.arrow_drop_down, color: gray700),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: gray700, fontSize: 16),
                        underline: const SizedBox(),
                        onChanged: (String? newValue) {
                          controller.category = newValue!;
                        },
                        items: <String>['Work', 'Personal', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            })
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
              
                    GestureDetector(
                      onTap: _showDatePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: gray300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.calendar,
                              color: gray700,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              controller.selectedDate != null
                                  ? _formatDate(controller.selectedDate!)
                                  : 'Select date',
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.selectedDate != null
                                    ? gray700
                                    : gray300,
                              ),
                            ),
                            SizedBox(height: 16),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: gray300,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
              
                    GestureDetector(
                      onTap: _showTimePicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          border: Border.all(color: gray300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.clock,
                              color: gray700,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              controller.selectedTime != null
                                  ? _formatTime(controller.selectedTime!)
                                  : 'Select time',
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.selectedTime != null
                                    ? gray700
                                    : gray300,
                              ),
                            ),
                            SizedBox(height: 16),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: gray300,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.canSaveReminder
                          ? () {
                              controller.saveReminder(context);
                              Navigator.maybePop(context);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: gray700,
                      ),
                      child: const Text(
                        'Save Reminder',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
