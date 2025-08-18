import 'package:flutter/material.dart';
import 'package:notesapp/model/reminder.dart';
import 'package:notesapp/services/notification_logic.dart';

class ReminderProvider extends ChangeNotifier {
  final List<Reminder> _reminders = [];
  List<Reminder> get reminders =>
      [..._searchTerm == "" ? _reminders : _reminders.where(_test)]
        ..sort(_compare);

  int _compare(Reminder reminder1, Reminder reminder2) {
    return orderby == ReminderOrderOptions.dateTime
        ? (_isDescending
              ? reminder2.dateTime.compareTo(reminder1.dateTime)
              : reminder1.dateTime.compareTo(reminder2.dateTime))
        : (_isDescending
              ? reminder2.dateModified.compareTo(reminder1.dateModified)
              : reminder1.dateModified.compareTo(reminder2.dateModified));
  }

  bool _test(Reminder reminder) {
    final term = _searchTerm.toLowerCase().trim();
    final title = reminder.title.toLowerCase().trim();
    final description = reminder.description.toLowerCase().trim();
    final category = reminder.category.toLowerCase().trim();
    return title.contains(term) ||
        description.contains(term) ||
        category.contains(term);
  }

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _scheduleNotification(reminder);
    notifyListeners();
  }

  void updateReminder(Reminder reminder) {
    final index = _reminders.indexWhere((element) => element.id == reminder.id);
    if (index != -1) {
      if (_reminders[index].notificationId != null) {
        NotificationLogic.cancelNotification(_reminders[index].notificationId!);
      }
      _reminders[index] = reminder;
      _scheduleNotification(reminder);
      notifyListeners();
    }
  }

  void deleteReminder(Reminder reminder) {
    if (reminder.notificationId != null) {
      NotificationLogic.cancelNotification(reminder.notificationId!);
    }
    _reminders.remove(reminder);
    notifyListeners();
  }

  void toggleReminderCompletion(Reminder reminder) {
    final index = _reminders.indexWhere((element) => element.id == reminder.id);
    if (index != -1) {
      final updatedReminder = reminder.copyWith(
        isCompleted: !reminder.isCompleted,
        dateModified: DateTime.now().microsecondsSinceEpoch,
      );

      if (updatedReminder.isCompleted && reminder.notificationId != null) {
        NotificationLogic.cancelNotification(reminder.notificationId!);
      } else if (!updatedReminder.isCompleted) {
        _scheduleNotification(updatedReminder);
      }

      _reminders[index] = updatedReminder;
      notifyListeners();
    }
  }

  void _scheduleNotification(Reminder reminder) {
    if (!reminder.isCompleted && reminder.dateTime.isAfter(DateTime.now())) {
      final notificationId = reminder.id.hashCode.abs();
      NotificationLogic.showNotification(
        id: notificationId,
        title: reminder.title,
        body: reminder.description,
        payload: reminder.id,
        dateTime: reminder.dateTime,
      );

      final index = _reminders.indexWhere(
        (element) => element.id == reminder.id,
      );
      if (index != -1) {
        _reminders[index] = reminder.copyWith(notificationId: notificationId);
      }
    }
  }

  Reminder? getReminderById(String id) {
    try {
      return _reminders.firstWhere((reminder) => reminder.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Reminder> getUpcomingReminders() {
    final now = DateTime.now();
    return _reminders
        .where(
          (reminder) => !reminder.isCompleted && reminder.dateTime.isAfter(now),
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Reminder> getCompletedReminders() {
    return _reminders.where((reminder) => reminder.isCompleted).toList()
      ..sort((a, b) => b.dateModified.compareTo(a.dateModified));
  }

  List<Reminder> getOverdueReminders() {
    final now = DateTime.now();
    return _reminders
        .where(
          (reminder) =>
              !reminder.isCompleted && reminder.dateTime.isBefore(now),
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  late ReminderOrderOptions _orderby = ReminderOrderOptions.dateTime;
  set orderby(ReminderOrderOptions value) {
    _orderby = value;
    notifyListeners();
  }

  ReminderOrderOptions get orderby => _orderby;

  bool _isDescending = false;
  set isDescending(bool value) {
    _isDescending = value;
    notifyListeners();
  }

  bool get isDescending => _isDescending;

  String _searchTerm = "";
  String get searchTerm => _searchTerm;
  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  void clearCompletedReminders() {
    final completedReminders = getCompletedReminders();
    for (final reminder in completedReminders) {
      deleteReminder(reminder);
    }
  }
}

enum ReminderOrderOptions {
  dateTime,
  dateModified,
  dateCreated;

  String get name {
    return switch (this) {
      ReminderOrderOptions.dateTime => 'Date & Time',
      ReminderOrderOptions.dateModified => 'Date Modified',
      ReminderOrderOptions.dateCreated => 'Date Created',
    };
  }
}
