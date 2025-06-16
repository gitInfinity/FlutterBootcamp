import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // In a real app, you might load these from a database.
  // Here we start with some demo notes; you could also start with an empty list.
  List<Map<String, String>> _notes = [
    {'title': 'Note 1', 'content': 'This is the content of the first note.'},
    {'title': 'Note 2', 'content': 'Second note content goes here.'},
    {'title': 'Note 3', 'content': 'Third note content goes here.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.note, size: 28),
            SizedBox(width: 8),
            Text(
              "My Notes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text("No notes yet"))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  title: Text(
                    note['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    note['content']!.length > 50
                        ? note['content']!.substring(0, 50) + '...'
                        : note['content']!,
                  ),
                  onTap: () async {
                    // Navigate to detail, await edited data:
                    final result = await Navigator.pushNamed(
                      context,
                      "/notesdetailscreen",
                      arguments: {
                        'noteId': note['title']!,
                        'content': note['content']!,
                      },
                    );
                    if (result is Map<String, String>) {
                      // Update this note in the list
                      setState(() {
                        _notes[index] = {
                          'title': result['noteId']!,
                          'content': result['content']!,
                        };
                      });
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddNotesScreen, await new note data:
          final result = await Navigator.pushNamed(context, "/addnotesscreen");
          if (result is Map<String, String>) {
            setState(() {
              _notes.add({
                'title': result['noteId']!,
                'content': result['content']!,
              });
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
