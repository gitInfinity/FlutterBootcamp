import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/widgets/outlined_icon_button.dart';
import 'package:notes_app/colors.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/change_notifiers/reminder_controller.dart';
import 'dart:math' as math;

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
        return _CustomTimePickerDialog(
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
            body: Padding(
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
                          const Spacer(),
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
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: gray300,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
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
        );
      },
    );
  }
}

class _CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const _CustomTimePickerDialog({
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<_CustomTimePickerDialog> createState() =>
      _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<_CustomTimePickerDialog> {
  late int _selectedHour;
  late int _selectedMinute;
  late DayPeriod _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialTime.hourOfPeriod == 0
        ? 12
        : widget.initialTime.hourOfPeriod;
    _selectedMinute = widget.initialTime.minute;
    _selectedPeriod = widget.initialTime.period;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedHour.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const Text(
                  ' : ',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Text(
                  _selectedMinute.toString().padLeft(2, '0'),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPeriod = DayPeriod.am),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == DayPeriod.am
                              ? Colors.pink.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'AM',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _selectedPeriod == DayPeriod.am
                                ? Colors.pink
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPeriod = DayPeriod.pm),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == DayPeriod.pm
                              ? Colors.pink.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          'PM',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _selectedPeriod == DayPeriod.pm
                                ? Colors.pink
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            Column(
              children: [
                Text(
                  'Touch inner ring for hours, outer ring for minutes',
                  style: TextStyle(
                    fontSize: 12,
                    color: gray500,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CustomPaint(
                    painter: _ClockPainter(
                      hour: _selectedHour,
                      minute: _selectedMinute,
                      onHourChanged: (hour) =>
                          setState(() => _selectedHour = hour),
                      onMinuteChanged: (minute) =>
                          setState(() => _selectedMinute = minute),
                    ),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final center = Offset(100, 100);
                        final position = details.localPosition - center;
                        final angle =
                            (position.direction + 1.5708) % (2 * 3.14159);
                        final distance = position.distance;

                        if (distance > 30 && distance < 70) {
                          int hour =
                              ((angle / (2 * 3.14159)) * 12).round() % 12;
                          if (hour == 0) hour = 12;
                          setState(() => _selectedHour = hour);
                        } else if (distance > 70 && distance < 100) {
                          int minute =
                              ((angle / (2 * 3.14159)) * 60).round() % 60;
                          setState(() => _selectedMinute = minute);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final hour24 = _selectedPeriod == DayPeriod.am
                            ? (_selectedHour == 12 ? 0 : _selectedHour)
                            : (_selectedHour == 12 ? 12 : _selectedHour + 12);
                        widget.onTimeSelected(
                          TimeOfDay(hour: hour24, minute: _selectedMinute),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final int hour;
  final int minute;
  final Function(int) onHourChanged;
  final Function(int) onMinuteChanged;

  _ClockPainter({
    required this.hour,
    required this.minute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final circlePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 10, circlePaint);

    final hourAreaPaint = Paint()
      ..color = Colors.deepPurple.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, 70, hourAreaPaint);

    final minuteAreaPaint = Paint()
      ..color = Colors.deepPurple.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, 100, minuteAreaPaint);

    for (int i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * 3.14159 / 180;
      final x = center.dx + (radius - 30) * 0.7 * math.cos(angle);
      final y = center.dy + (radius - 30) * 0.7 * math.sin(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: i.toString(),
          style: TextStyle(
            color: i == hour ? Colors.white : Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      if (i == hour) {
        canvas.drawCircle(Offset(x, y), 15, Paint()..color = Colors.deepPurple);
      }

      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    for (int i = 0; i < 60; i += 5) {
      if (i % 15 == 0) continue;
      final angle = (i * 6 - 90) * 3.14159 / 180;
      final x = center.dx + (radius - 20) * math.cos(angle);
      final y = center.dy + (radius - 20) * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.grey.shade400);
    }

    if (minute % 5 == 0) {
      final angle = (minute * 6 - 90) * 3.14159 / 180;
      final x = center.dx + (radius - 20) * math.cos(angle);
      final y = center.dy + (radius - 20) * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = Colors.deepPurple);
    }

    final hourAngle = ((hour % 12) * 30 + minute * 0.5 - 90) * 3.14159 / 180;
    final minuteAngle = (minute * 6 - 90) * 3.14159 / 180;

    final hourHandPaint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(
        center.dx + (radius - 50) * 0.6 * math.cos(hourAngle),
        center.dy + (radius - 50) * 0.6 * math.sin(hourAngle),
      ),
      hourHandPaint,
    );

    final minuteHandPaint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      Offset(
        center.dx + (radius - 30) * math.cos(minuteAngle),
        center.dy + (radius - 30) * math.sin(minuteAngle),
      ),
      minuteHandPaint,
    );

    canvas.drawCircle(center, 4, Paint()..color = Colors.deepPurple);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
