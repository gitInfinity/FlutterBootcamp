import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notesapp/colors.dart';

class NoteToolBar extends StatelessWidget {
  const NoteToolBar({super.key, required this.quillController});

  final QuillController quillController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(color: primary),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: primary, offset: Offset(4, 4))],
      ),
      child: QuillSimpleToolbar(
        controller: quillController,
        config: const QuillSimpleToolbarConfig(
          multiRowsDisplay: false,
          showBoldButton: true,
          showFontFamily: false,
          showFontSize: false,
          showSubscript: false,
          showSuperscript: false,
          showInlineCode: false,
          showAlignmentButtons: false,
          showDividers: false,
          showDirection: false,
          showHeaderStyle: false,
          showListCheck: false,
          showCodeBlock: false,
          showQuote: false,
          showIndent: false,
          showLink: false,
        ),
      ),
    );
  }
}
