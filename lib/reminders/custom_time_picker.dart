import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:notesapp/colors.dart';

class CustomTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const CustomTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<CustomTimePickerDialog> createState() => _CustomTimePickerDialogState();
}

class _CustomTimePickerDialogState extends State<CustomTimePickerDialog> {
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Time display - takes available space
                Expanded(
                  child: Row(
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
                    ],
                  ),
                ),
                // AM/PM buttons - fixed width
                SizedBox(
                  width: 60,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedPeriod = DayPeriod.am),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
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
                            horizontal: 8,
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
