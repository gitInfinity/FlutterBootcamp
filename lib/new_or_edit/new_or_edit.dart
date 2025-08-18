import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/change_notifiers/new_note_controller.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/widgets/confirmation_dialog.dart';
import 'package:notesapp/widgets/note_metadata.dart';
import 'package:notesapp/widgets/note_toolbar.dart';
import 'package:notesapp/widgets/outlined_icon_button.dart';
import 'package:provider/provider.dart';

class NewOrEditPage extends StatefulWidget {
  const NewOrEditPage({super.key, required this.isNewNote});

  final bool isNewNote;

  @override
  State<NewOrEditPage> createState() => _NeworEditNotesStateState();
}

class _NeworEditNotesStateState extends State<NewOrEditPage> {
  late final QuillController quillController;
  late final FocusNode focusNode;
  late final TextEditingController titleController;
  late final NewNote newNoteController;
  @override
  void initState() {
    super.initState();
    newNoteController = context.read<NewNote>();
    titleController = TextEditingController(text: newNoteController.title);
    quillController = QuillController.basic()
      ..addListener(() {
        newNoteController.content = quillController.document;
      });
    focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      if (widget.isNewNote) {
        focusNode.requestFocus();
        newNoteController.readOnly = false;
      } else {
        newNoteController.readOnly = true;
        quillController.document = newNoteController.content;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    focusNode.dispose();
    quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!newNoteController.cansaveNote) {
          Navigator.pop(context);
          return;
        }
        final bool? shouldSave = await showDialog<bool?>(
          context: context,
          builder: (_) =>
              ConfirmationDialogue(confirmation: "Do you want to save?"),
        );
        if (shouldSave == null) return;
        if (!context.mounted) return;
        if (shouldSave) newNoteController.saveNote(context);
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
          title: Text(widget.isNewNote ? "New Note" : "Edit note"),
          actions: [
            Selector<NewNote, bool>(
              selector: (context, newNoteController) =>
                  newNoteController.readOnly,
              builder: (context, readOnly, child) => NoteIconButtonOutlined(
                icon: readOnly
                    ? FontAwesomeIcons.pen
                    : FontAwesomeIcons.bookOpen,
                onPressed: () {
                  newNoteController.readOnly = !readOnly;
                  if (newNoteController.readOnly) {
                    FocusScope.of(context).unfocus();
                  } else {
                    focusNode.requestFocus();
                  }
                },
              ),
            ),
            Selector<NewNote, bool>(
              selector: (_, newNoteController) => newNoteController.cansaveNote,
              builder: (_, canSaveNote, _) => NoteIconButtonOutlined(
                icon: FontAwesomeIcons.check,
                onPressed: canSaveNote
                    ? () {
                        newNoteController.saveNote(context);
                        Navigator.pop(context);
                      }
                    : null,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Selector<NewNote, bool>(
                selector: (context, newNoteController) =>
                    newNoteController.readOnly,
                builder: (context, readOnly, child) => TextField(
                  controller: titleController,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: "Title here",
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: gray300),
                  ),
                  canRequestFocus: !readOnly,
                  onChanged: (value) {
                    newNoteController.title = value;
                  },
                ),
              ),
              NoteMetadata(note: newNoteController.note),
              Divider(color: gray700),
              Expanded(
                child: Selector<NewNote, bool>(
                  selector: (_, newNoteController) =>
                      newNoteController.readOnly,
                  builder: (_, readOnly, _) => Column(
                    children: [
                      Expanded(
                        child: QuillEditor.basic(
                          controller: quillController,
                          config: QuillEditorConfig(
                            placeholder: "Note here...",
                            checkBoxReadOnly: readOnly,
                          ),
                          focusNode: focusNode,
                        ),
                      ),
                      if (!readOnly)
                        NoteToolBar(quillController: quillController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
