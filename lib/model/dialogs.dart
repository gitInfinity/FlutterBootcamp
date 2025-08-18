import 'package:flutter/material.dart';
import 'package:notesapp/widgets/new_note_dialog.dart';
import 'package:notesapp/widgets/tags_Dialog.dart';

Future<String?> shownewTagDialogue({
  required BuildContext context,
  String? tag,
}) {
  return showDialog<String?>(
    barrierDismissible: true,
    context: context,
    builder: (context) => tags_Dialog(child: NewNoteDialog(tag: tag)),
  );
}
