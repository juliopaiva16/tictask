import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/tag.dart';
import 'tag_selector.dart';
import 'custom_text_field.dart';

/// A reusable form widget for creating or editing a Task.
class TaskForm extends StatefulWidget {
  final List<Tag> availableTags;
  final Task? initialTask;
  final void Function(String name, List<Tag> tags, {String? description}) onSubmit;
  final void Function()? onDelete;

  const TaskForm({
    super.key,
    required this.availableTags,
    this.initialTask,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late List<Tag> _selectedTags;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTask?.title ?? '');
    _descriptionController = TextEditingController(text: widget.initialTask?.description ?? '');
    _selectedTags = widget.initialTask != null
        ? widget.availableTags.where((tag) => widget.initialTask!.tagIds.contains(tag.id)).toList()
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
        CustomTextField(
          controller: _nameController,
          label: 'Task name',
        ),
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
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.onDelete != null)
              TextButton(
                onPressed: widget.onDelete,
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  _nameController.text.trim(),
                  _selectedTags,
                  description: _descriptionController.text.trim(),
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
