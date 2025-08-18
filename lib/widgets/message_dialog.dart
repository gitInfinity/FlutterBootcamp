import 'package:flutter/material.dart';
import 'package:notesapp/widgets/note_button.dart';
import 'package:notesapp/widgets/tags_Dialog.dart';

class MessageDialog extends StatelessWidget {
  const MessageDialog({required this.confirmation, super.key});
  final String confirmation;
  @override
  Widget build(BuildContext context) {
    return tags_Dialog(
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 18,
          children: [
            Text(
              confirmation,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                NoteButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
