import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../models/tag.dart';
import '../viewmodels/task_viewmodel.dart';
import 'task_view.dart';

/// View for managing a list of tasks, each with its own name and tags.
class TaskListView extends StatefulWidget {
  final List<Tag> availableTags;

  const TaskListView({super.key, required this.availableTags});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  final List<Task> _tasks = [];
  final TextEditingController _taskNameController = TextEditingController();
  final List<Tag> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final box = await Hive.openBox<Task>('tasks');
    setState(() {
      _tasks.clear();
      _tasks.addAll(box.values);
    });
  }

  void _createTask() async {
    final name = _taskNameController.text.trim();
    if (name.isNotEmpty) {
      // Garante unicidade dos ids das tags
      final uniqueTagIds = {
        for (final tag in _selectedTags) tag.id: tag
      }.keys.toList();
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: name,
        tagIds: uniqueTagIds,
      );
      final box = await Hive.openBox<Task>('tasks');
      await box.add(task);
      await _loadTasks();
      setState(() {
        _taskNameController.clear();
        _selectedTags.clear();
      });
    }
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

  void _openTask(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TaskView(viewModel: TaskViewModel(task: task)),
      ),
    );
  }

  Widget _buildTagChip(Tag tag, {bool selected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: FilterChip(
        label: Text(tag.name),
        avatar: Icon(tag.icon, color: tag.color),
        selected: selected,
        selectedColor: tag.color.withAlpha(51),
        backgroundColor: tag.color.withAlpha(26),
        onSelected: (_) => onTap?.call(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _taskNameController,
              decoration: const InputDecoration(labelText: 'Task name'),
            ),
            const SizedBox(height: 8),
            Wrap(
              children: widget.availableTags
                  .map((tag) => _buildTagChip(
                        tag,
                        selected: _selectedTags.contains(tag),
                        onTap: () => _toggleTag(tag),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _createTask,
              child: const Text('Create Task'),
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  // Busca as instâncias de Tag usando os ids salvos
                  final displayTags = task.tagIds
                      .map((id) => widget.availableTags.firstWhere(
                            (t) => t.id == id,
                            orElse: () => Tag(
                              id: id,
                              name: id,
                              iconCodePoint: Icons.label.codePoint,
                              colorValue: Colors.grey.toARGB32(),
                            ),
                          ))
                      .whereType<Tag>()
                      .toList();
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Wrap(
                      children: displayTags
                          .map((tag) => _buildTagChip(tag))
                          .toList(),
                    ),
                    onTap: () => _openTask(task),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

