import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notesapp/change_notifiers/note_provider.dart';
import 'package:notesapp/model/note.dart';
import 'package:provider/provider.dart';

class NewNote extends ChangeNotifier {
  Note? _note;
  set note(Note? value) {
    _note = value;
    _title = _note!.title ?? "";
    _content = Document.fromJson(jsonDecode(_note!.contentJSON));
    _tags.addAll(note!.tags ?? []);
    notifyListeners();
  }

  Note? get note => _note;

  bool get isNewNote => _note == null;

  bool _readOnly = false;
  set readOnly(bool value) {
    _readOnly = value;
    notifyListeners();
  }

  bool get readOnly => _readOnly;

  String _title = "";
  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get title => _title.trim();

  Document _content = Document();
  set content(Document value) {
    _content = value;
    notifyListeners();
  }

  Document get content => _content;

  final List<String> _tags = [];
  void addTags(String value) {
    _tags.add(value);
    notifyListeners();
  }

  List<String> get tags => [..._tags];

  void removeTag(int index) {
    _tags.removeAt(index);
    notifyListeners();
  }

  void updateTag(String tag, int index) {
    _tags[index] = tag;
    notifyListeners();
  }

  bool get cansaveNote {
    final String? newTitle = title.isNotEmpty ? title : null;
    final String? newContent = content.toPlainText().trim().isNotEmpty
        ? content.toPlainText().trim()
        : null;
    if (isNewNote) {
      return newTitle != null || newContent != null;
    } else {
      final newContentJson = jsonEncode(content.toDelta().toJson());
      return (newTitle != note!.title ||
              newContentJson != note!.contentJSON ||
              !listEquals(tags, note!.tags)) &&
          (newTitle != null || newContent != null);
    }
  }

  void saveNote(BuildContext context) {
    final String? newTitle = title.isNotEmpty ? title : null;
    final String? newContent = content.toPlainText().trim().isNotEmpty
        ? content.toPlainText().trim()
        : null;
    final String contentJSON = jsonEncode(_content.toDelta().toJson());
    final int now = DateTime.now().microsecondsSinceEpoch;
    final Note note = Note(
      title: newTitle,
      content: newContent,
      contentJSON: contentJSON,
      dateCreated: isNewNote ? now : _note!.dateCreated,
      dateModified: now,
      tags: tags,
    );
    final notesProvider = context.read<NoteProvider>();
    isNewNote ? notesProvider.addNote(note) : notesProvider.updateNote(note);
  }
}
