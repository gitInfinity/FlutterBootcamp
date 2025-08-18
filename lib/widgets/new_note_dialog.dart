import 'package:flutter/material.dart';
import 'package:notesapp/widgets/note_button.dart';
import 'package:notesapp/widgets/note_form_field.dart';

class NewNoteDialog extends StatefulWidget {
  const NewNoteDialog({super.key, this.tag});

  final String? tag;

  @override
  State<NewNoteDialog> createState() => _NewNoteDialogState();
}

class _NewNoteDialogState extends State<NewNoteDialog> {
  late final TextEditingController tagController;
  late final GlobalKey<FormFieldState> tagKey;

  @override
  void initState() {
    super.initState();
    tagController = TextEditingController(text: widget.tag);
    tagKey = GlobalKey<FormFieldState>();
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Add tag",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "fredoka",
          ),
        ),
        NoteFormField(
          controller: tagController,
          key: tagKey,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "No tag added";
            } else if (value.trim().length > 16) {
              return "Tag too long";
            } else {
              return null;
            }
          },
          onChanged: (value) {
            tagKey.currentState?.validate();
          },
          autofocus: true,
        ),
        NoteButton(
          child: Text("Add tag"),
          onPressed: () {
            if (tagKey.currentState?.validate() ?? false) {
              Navigator.pop(context, tagController.text.trim());
            }
          },
        ),
      ],
    );
  }
}
