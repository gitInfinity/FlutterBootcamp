import 'package:flutter/material.dart';
import 'package:notesapp/model/note.dart';

extension ListDeepContains on List<String> {
  bool deepContains(String term) =>
      any((element) => element.contains(term)) || contains(term);
}

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];
  List<Note> get notes =>
      [..._searchTerm == "" ? _notes : _notes.where(_test)]..sort(_compare);

  int _compare(Note note1, note2) {
    return orderby == OrderOptions.dateModified
        ? (_isDescending
              ? note2.dateModified.compareTo(note1.dateModified)
              : note1.dateModified.compareTo(note2.dateModified))
        : (_isDescending
              ? note2.dateCreated.compareTo(note1.dateCreated)
              : note1.dateCreated.compareTo(note2.dateCreated));
  }

  bool _test(Note note1) {
    final term = _searchTerm.toLowerCase().trim();
    final title = note1.title?.toLowerCase().trim() ?? '';
    final content = note1.content?.toLowerCase().trim() ?? '';
    final tags =
        note1.tags?.map((toElement) => toElement.toLowerCase()).toList() ?? [];
    return title.contains(term) ||
        content.contains(term) ||
        tags.deepContains(term);
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  void updateNote(Note note) {
    final index = _notes.indexWhere(
      (element) => element.dateCreated == note.dateCreated,
    );
    _notes[index] = note;
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    notifyListeners();
  }

  late OrderOptions _orderby = OrderOptions.dateModified;
  set orderby(OrderOptions value) {
    _orderby = value;
    notifyListeners();
  }

  OrderOptions get orderby => _orderby;

  bool _isDescending = true;
  set isDescending(bool value) {
    _isDescending = value;
    notifyListeners();
  }

  bool get isDescending => _isDescending;

  bool _isGrid = true;
  set isGrid(bool value) {
    _isGrid = value;
    notifyListeners();
  }

  bool get isGrid => _isGrid;

  String _searchTerm = "";
  String get searchTerm => _searchTerm;
  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }
}

enum OrderOptions {
  dateModified,
  dateCreated;

  String get name {
    return switch (this) {
      OrderOptions.dateModified => 'Date Modified',
      OrderOptions.dateCreated => 'Date Created',
    };
  }
}
