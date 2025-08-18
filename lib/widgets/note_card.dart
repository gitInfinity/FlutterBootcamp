import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/change_notifiers/new_note_controller.dart';
import 'package:notesapp/change_notifiers/note_provider.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/model/utils.dart';
import 'package:notesapp/new_or_edit/new_or_edit.dart';
import 'package:notesapp/widgets/confirmation_dialog.dart';
import 'package:notesapp/widgets/note_tags.dart';
import 'package:notesapp/widgets/tags_Dialog.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.isInGrid, required this.note});

  final bool isInGrid;
  final Note note;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => NewNote()..note = note,
              child: const NewOrEditPage(isNewNote: false),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: primary.withValues(), offset: Offset(2, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (note.title != null) ...[
                Text(
                  note.title!,
                  maxLines: 1,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
              if (note.tags != null) ...[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        note.tags!.length,
                        (index) => NoteTags(label: note.tags![index]),
                      ),
                    ),
                  ),
                ),
              ],
              if (note.content != null)
                isInGrid
                    ? Expanded(
                        child: Text(
                          note.content!,
                          style: TextStyle(color: gray900),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Text(
                        note.content!,
                        style: TextStyle(color: gray900),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
              if (isInGrid) Spacer(),
              Row(
                children: [
                  Text(
                    toShortDate(note.dateCreated),
                    style: TextStyle(
                      fontSize: 12,
                      color: gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      final shouldDelete =
                          await showDialog<bool?>(
                            context: context,
                            builder: (_) => tags_Dialog(
                              child: ConfirmationDialogue(
                                confirmation: "Delete note?",
                              ),
                            ),
                          ) ??
                          false;
                      if (shouldDelete && context.mounted) {
                        context.read<NoteProvider>().deleteNote(note);
                      }
                    },
                    child: FaIcon(
                      FontAwesomeIcons.trash,
                      size: 12,
                      color: gray500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
