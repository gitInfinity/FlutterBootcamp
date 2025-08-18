import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/colors.dart';

class NotesFAB extends StatelessWidget {
  const NotesFAB({
    super.key,
    required this.onPressed,
    this.icon = FontAwesomeIcons.plus,
    this.size = 150.0,
    this.borderRadius = 16.0,
    this.shadowOffset = const Offset(4, 4),
    this.shadowColor = Colors.black,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final double size;
  final double borderRadius;
  final Offset shadowOffset;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [BoxShadow(color: shadowColor, offset: shadowOffset)],
      ),
      child: FloatingActionButton.large(
        onPressed: onPressed,
        backgroundColor: primary,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        child: FaIcon(icon, size: size * 0.3),
      ),
    );
  }
}
