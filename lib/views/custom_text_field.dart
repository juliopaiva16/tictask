import 'package:flutter/material.dart';

/// Reusable custom text field widget for forms.
class CustomTextField extends StatelessWidget {
  /// Controller for the text field.
  final TextEditingController controller;

  /// Label for the text field.
  final String label;

  /// Maximum number of lines for the text field.
  final int? maxLines;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Keyboard type for the text field.
  final TextInputType? keyboardType;

  /// Optional validator function for the text field.
  final String? Function(String?)? validator;

  /// Creates a [CustomTextField] widget.
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines,
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }
}
