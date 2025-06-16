import 'package:flutter/material.dart';
import 'package:week3app/Screens/AddNotes.dart';
import 'package:week3app/Screens/NotesDetail.dart';
import 'Screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        "/homescreen": (context) => HomeScreen(),
        "/addnotesscreen": (context) => AddNotesScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/notesdetailscreen') {
          final args = settings.arguments;
          if (args is Map<String, String> &&
              args.containsKey('noteId') &&
              args.containsKey('content')) {
            return MaterialPageRoute(
              builder: (context) => NotesDetailScreen(
                noteId: args['noteId']!,
                content: args['content']!,
              ),
            );
          } else {
            return MaterialPageRoute(builder: (context) => HomeScreen());
          }
        }
        return null;
      },
    );
  }
}
