import 'package:flutter/material.dart';
import 'package:notesapp/colors.dart';

class tags_Dialog extends StatefulWidget {
  const tags_Dialog({super.key, required this.child});
  final Widget child;

  @override
  State<tags_Dialog> createState() => _tags_DialogState();
}

class _tags_DialogState extends State<tags_Dialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: white,
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(offset: Offset(4, 4))],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
