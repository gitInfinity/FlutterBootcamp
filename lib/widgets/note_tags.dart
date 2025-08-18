import 'package:flutter/material.dart';
import 'package:notesapp/colors.dart';

class NoteTags extends StatelessWidget {
  const NoteTags({required this.label, this.onClose, this.onTap, super.key});

  final String label;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: gray100,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: EdgeInsets.only(right: 4),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: gray700,
                fontSize: onClose != null ? 15 : 12,
              ),
            ),
            if (onClose != null) ...[
              SizedBox(width: 4),
              GestureDetector(onTap: onClose, child: Icon(Icons.close)),
            ],
          ],
        ),
      ),
    );
  }
}
