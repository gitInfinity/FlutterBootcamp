import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/change_notifiers/new_note_controller.dart';
import 'package:notes_app/change_notifiers/note_provider.dart';
import 'package:notes_app/colors.dart';
import 'package:notes_app/model/auth.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/new_or_edit/new_or_edit.dart';
import 'package:notes_app/widgets/confirmation_dialog.dart';
import 'package:notes_app/widgets/main_view.dart';
import 'package:notes_app/widgets/note_card.dart';
import 'package:notes_app/widgets/outlined_icon_button.dart';
import 'package:notes_app/widgets/notes_fab.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peach Paper'),
        actions: [
          NoteIconButtonOutlined(
            icon: FontAwesomeIcons.rightFromBracket,
            onPressed: () async {
              final bool shouldLogout =
                  await showDialog<bool?>(
                    context: context,
                    builder: (_) => ConfirmationDialogue(
                      confirmation: "Do you want to logout?",
                    ),
                  ) ??
                  false;
              if (shouldLogout) Auth.logout();
            },
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: NotesFAB(
        onPressed: () {
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
      body: Consumer<NoteProvider>(
        builder: (context, notesProvider, child) {
          final List<Note> notes = notesProvider.notes;
          return notes.isEmpty && notesProvider.searchTerm.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/download-removebg-preview.png',
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No notes yet',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: gray500,
                          fontFamily: 'Fredoka',
                        ),
                      ),
                    ],
                  ),
                )
              : MainView(notes: notes);
        },
      ),
    );
  }
}

class SeachField extends StatelessWidget {
  const SeachField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search notes",
        prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
        fillColor: white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: (value) {
        context.read<NoteProvider>().searchTerm = value;
      },
    );
  }
}

class NotesList extends StatefulWidget {
  const NotesList({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: NoteCard(isInGrid: false, note: widget.notes[index]),
        );
      },
    );
  }
}

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key, required this.notes});

  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, int index) {
        return NoteCard(isInGrid: true, note: notes[index]);
      },
    );
  }
}
