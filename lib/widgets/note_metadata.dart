import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/change_notifiers/new_note_controller.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/model/dialogs.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/model/utils.dart';
import 'package:notesapp/widgets/icon_button.dart';
import 'package:notesapp/widgets/note_tags.dart';
import 'package:provider/provider.dart';

class NoteMetadata extends StatefulWidget {
  const NoteMetadata({super.key, required this.note});

  final Note? note;

  @override
  State<NoteMetadata> createState() => _NoteMetadataState();
}

class _NoteMetadataState extends State<NoteMetadata> {
  late final NewNote newNoteController;

  @override
  void initState() {
    super.initState();
    newNoteController = context.read();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.note != null) ...[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Last Modified: ",
                  style: TextStyle(color: gray300, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  toLongDate(widget.note!.dateModified),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Created: ",
                  style: TextStyle(color: gray300, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  toLongDate(widget.note!.dateCreated),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Text(
                    "Tags",
                    style: TextStyle(
                      color: gray300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon_Button(
                    icon: FontAwesomeIcons.circlePlus,
                    onPressed: () async {
                      final String? tag = await shownewTagDialogue(
                        context: context,
                      );
                      if (tag != null) {
                        newNoteController.addTags(tag);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Selector<NewNote, List<String>>(
                selector: (_, newNoteController) => newNoteController.tags,
                builder: (_, tags, _) => tags.isEmpty
                    ? Text(
                        "No tags added",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            tags.length,
                            (index) => NoteTags(
                              label: tags[index],
                              onClose: () {
                                newNoteController.removeTag(index);
                              },
                              onTap: () async {
                                final String? tag = await shownewTagDialogue(
                                  context: context,
                                  tag: tags[index],
                                );
                                if (tag != null && tag != tags[index]) {
                                  newNoteController.updateTag(tag, index);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
