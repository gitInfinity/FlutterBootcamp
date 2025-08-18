import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/change_notifiers/note_provider.dart';
import 'package:notesapp/colors.dart';
import 'package:notesapp/main_page/main_page.dart';
import 'package:notesapp/model/note.dart';
import 'package:notesapp/widgets/icon_button.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, required this.notes});
  final List<Note> notes;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (_, notesProvider, __) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
          children: [
            SeachField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: primary,
                      fontFamily: 'Fredoka',
                    ),
                  ),
                ],
              ),
            ),
            if (widget.notes.isNotEmpty) ...[
              Row(
                children: [
                  Icon_Button(
                    icon: notesProvider.isDescending
                        ? FontAwesomeIcons.arrowDown
                        : FontAwesomeIcons.arrowUp,
                    size: 18,
                    onPressed: () {
                      setState(() {
                        notesProvider.isDescending =
                            !notesProvider.isDescending;
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  DropdownButton<OrderOptions>(
                    value: notesProvider.orderby,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: FaIcon(
                        FontAwesomeIcons.arrowDownWideShort,
                        size: 18,
                      ),
                    ),
                    underline: SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(16),
                    isDense: true,
                    items: OrderOptions.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Row(
                              children: [
                                Text(e.name),
                                if (e == notesProvider.orderby) ...[
                                  Icon(Icons.check),
                                ],
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    selectedItemBuilder: (context) =>
                        OrderOptions.values.map((e) => Text(e.name)).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        notesProvider.orderby = newValue!;
                      });
                    },
                  ),
                  Spacer(),
                  Icon_Button(
                    icon: notesProvider.isGrid
                        ? FontAwesomeIcons.tableCellsLarge
                        : FontAwesomeIcons.bars,
                    size: 18,
                    onPressed: () {
                      setState(() {
                        notesProvider.isGrid = !notesProvider.isGrid;
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: notesProvider.isGrid
                    ? NotesGrid(notes: widget.notes)
                    : NotesList(notes: widget.notes),
              ),
            ] else
              Expanded(
                child: Container(
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
