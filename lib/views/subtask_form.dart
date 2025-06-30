import 'package:flutter/material.dart';
import '../models/subtask.dart';
import '../models/tag.dart';
import 'tag_selector.dart';
import 'custom_text_field.dart';

/// A reusable form widget for creating or editing a Subtask.
class SubtaskForm extends StatefulWidget {
  /// The initial subtask to edit, or null to create a new one.
  final Subtask? initialSubtask;

  /// List of available tags to choose from
  final List<Tag> availableTags;

  /// Callback when the form is submitted with name, description, and tags.
  final void Function(String name, String description, List<Tag> tags) onSubmit;

  /// Callback when "Add New Tag" button is pressed
  final VoidCallback? onAddNewTag;

  /// Creates a [SubtaskForm] widget.
  const SubtaskForm({
    super.key,
    this.initialSubtask,
    required this.availableTags,
    required this.onSubmit,
    this.onAddNewTag,
  });

  @override
  State<SubtaskForm> createState() => _SubtaskFormState();
}

class _SubtaskFormState extends State<SubtaskForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late List<Tag> _selectedTags;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialSubtask?.title ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialSubtask?.notes ?? '',
    );
    _selectedTags =
        widget.initialSubtask != null &&
            widget.initialSubtask!.tagIds.isNotEmpty
        ? widget.availableTags
              .where((tag) => widget.initialSubtask!.tagIds.contains(tag.id))
              .toList()
        : <Tag>[];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleTag(Tag tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(controller: _nameController, label: 'Subtask name'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _descriptionController,
          label: 'Description',
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        TagSelector(
          availableTags: widget.availableTags,
          selectedTags: _selectedTags,
          onTagToggle: _toggleTag,
          onAddNewTag: widget.onAddNewTag,
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
                  _selectedTags,
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
