import 'package:flutter/material.dart';
import '../models/subtask.dart';

/// A reusable form widget for creating or editing a Subtask.
class SubtaskForm extends StatefulWidget {
  /// The initial subtask to edit, or null to create a new one.
  final Subtask? initialSubtask;
  /// Callback when the form is submitted with name and description.
  final void Function(String name, String description) onSubmit;

  /// Creates a [SubtaskForm] widget.
  const SubtaskForm({
    super.key,
    this.initialSubtask,
    required this.onSubmit,
  });

  @override
  State<SubtaskForm> createState() => _SubtaskFormState();
}

class _SubtaskFormState extends State<SubtaskForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialSubtask?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialSubtask?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Subtask name'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  _nameController.text.trim(),
                  _descriptionController.text.trim(),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
