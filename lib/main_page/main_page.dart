import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notes_app/change_notifiers/note_provider.dart';
import 'package:notes_app/change_notifiers/new_note_controller.dart';
import 'package:notes_app/change_notifiers/reminder_controller.dart';
import 'package:notes_app/colors.dart';
import 'package:notes_app/model/auth.dart';
import 'package:notes_app/model/note.dart';
import 'package:notes_app/new_or_edit/new_or_edit.dart';
import 'package:notes_app/reminders/reminders.dart';
import 'package:notes_app/reminders/reminders_list.dart';
import 'package:notes_app/services/notification_logic.dart';
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
  User? user;
  bool on = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    NotificationLogic.init(context, user!.uid);
    listenNotifications();
  }

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
      floatingActionButton: _currentIndex == 0
          ? NotesFAB(
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
            )
          : NotesFAB(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => ReminderController(),
                      child: const Reminders(isNewReminder: true),
                    ),
                  ),
                );
              },
            ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.noteSticky),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.bell),
            label: 'Reminders',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return Consumer<NoteProvider>(
          builder: (context, notesProvider, child) {
            final List<Note> notes = notesProvider.notes;
            return MainView(notes: notes);
          },
        );
      case 1:
        return const RemindersList();
      default:
        return const SizedBox.shrink();
    }
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
