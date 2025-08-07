import 'package:flutter/material.dart';
import 'package:notes_app/new_or_edit/new_or_edit.dart';
import 'package:notes_app/reminders/reminders.dart';
import 'package:notes_app/widgets/note_button.dart';
import 'package:notes_app/widgets/tags_Dialog.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/change_notifiers/new_note_controller.dart';
import 'package:notes_app/change_notifiers/reminder_controller.dart';

class CreateNewDialog extends StatelessWidget {
  const CreateNewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return tags_Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'What would you like to create?',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 18),
            Row(
              children: [
                NoteButton(
                  child: Text("New Note"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => NewNote(),
                          child: NewOrEditPage(isNewNote: true),
                        ),
                      ),
                    );
                  },
                ),
                Spacer(),
                NoteButton(
                  child: Text("New Reminder"),
                  onPressed: () {
                    Navigator.pop(context);
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
