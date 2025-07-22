import 'package:flutter/material.dart';
import 'package:notes_app/widgets/note_button.dart';

class ConfirmationDialogue extends StatelessWidget {
  const ConfirmationDialogue({
    required this.confirmation,
    super.key,
  });
  final String confirmation;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                label: "No",
                onPressed: () => Navigator.pop(context, false),
              ),
              Spacer(),
              NoteButton(
                label: "Yes",
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
