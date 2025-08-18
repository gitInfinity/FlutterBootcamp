import 'package:flutter/material.dart';
import 'package:notesapp/colors.dart';

class NoteFormField extends StatelessWidget {
  const NoteFormField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.hintText,
    this.suffix,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool autofocus;
  final String? hintText;
  final Widget? suffix;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      key: key,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: white,
        filled: true,
        suffix: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
        isDense: true,
      ),
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
    );
  }
}
