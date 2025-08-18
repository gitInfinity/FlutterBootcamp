import 'package:flutter/material.dart';
import 'package:notesapp/model/reminder.dart';
import 'package:notesapp/change_notifiers/reminder_provider.dart';
import 'package:provider/provider.dart';

class ReminderController extends ChangeNotifier {
  Reminder? _reminder;
  set reminder(Reminder? value) {
    _reminder = value;
    if (value != null) {
      _title = value.title;
      _description = value.description;
      _category = value.category;
      _selectedDate = value.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(value.dateTime);
    }
    notifyListeners();
  }

  Reminder? get reminder => _reminder;
  bool get isNewReminder => _reminder == null;

  String _title = "";
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get title => _title.trim();

  String _description = "";
  set description(String value) {
    _description = value;
    notifyListeners();
  }

  String get description => _description.trim();

  String _category = 'Work';
  set category(String value) {
    _category = value;
    notifyListeners();
  }

  String get category => _category;

  DateTime? _selectedDate;
  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  TimeOfDay? _selectedTime;
  set selectedTime(TimeOfDay? value) {
    _selectedTime = value;
    notifyListeners();
  }

  TimeOfDay? get selectedTime => _selectedTime;

  bool get canSaveReminder {
    if (isNewReminder) {
      return title.isNotEmpty && _selectedDate != null && _selectedTime != null;
    } else {
      final newDateTime = _getCombinedDateTime();
      return (title != reminder!.title ||
              description != reminder!.description ||
              category != reminder!.category ||
              newDateTime != reminder!.dateTime) &&
          title.isNotEmpty &&
          _selectedDate != null &&
          _selectedTime != null;
    }
  }

  DateTime? _getCombinedDateTime() {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  void saveReminder(BuildContext context) {
    final newDateTime = _getCombinedDateTime();
    if (newDateTime == null) return;

    final int now = DateTime.now().microsecondsSinceEpoch;
    final String id = isNewReminder
        ? DateTime.now().millisecondsSinceEpoch.toString()
        : _reminder!.id;

    final Reminder newReminder = Reminder(
      id: id,
      title: title,
      description: description,
      category: category,
      dateTime: newDateTime,
      dateCreated: isNewReminder ? now : _reminder!.dateCreated,
      dateModified: now,
      isCompleted: isNewReminder ? false : _reminder!.isCompleted,
      notificationId: isNewReminder ? null : _reminder!.notificationId,
    );

    final reminderProvider = context.read<ReminderProvider>();
    isNewReminder
        ? reminderProvider.addReminder(newReminder)
        : reminderProvider.updateReminder(newReminder);
  }

  void reset() {
    _title = "";
    _description = "";
    _category = 'Work';
    _selectedDate = null;
    _selectedTime = null;
    _reminder = null;
    notifyListeners();
  }
}
