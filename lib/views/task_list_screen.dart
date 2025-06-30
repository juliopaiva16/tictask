import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';
import '../models/tag.dart';
import '../utils/csv_exporter.dart';
import '../viewmodels/tag_viewmodel.dart';
import '../views/subtask_screen.dart';
import '../widgets/tictask_branding.dart';
import 'tag_management_screen.dart';
import 'task_form.dart';
import 'tag_selector.dart';

/// Main screen for listing and creating tasks.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  List<Tag> _availableTags = [];
  String _searchQuery = '';
  final List<Tag> _filterTags = [];
  final TagViewModel _tagViewModel = TagViewModel();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Loads all tasks from the Hive box and updates the state.
  Future<void> _loadData() async {
    await _loadTasks();
    await _loadTags();
  }
  
  Future<void> _loadTasks() async {
    final box = Hive.box<Task>('tasks');
    setState(() {
      _tasks = box.values.map((task) {
        return task;
      }).toList();
    });
  }
  
  Future<void> _loadTags() async {
    await _tagViewModel.loadTags();
    setState(() {
      _availableTags = _tagViewModel.tags;
    });
  }

  /// Returns the filtered list of tasks based on search query and selected tags.
  List<Task> get _filteredTasks {
    return _tasks.where((task) {
      final matchesQuery = _searchQuery.isEmpty ||
        task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesTags = _filterTags.isEmpty ||
        _filterTags.every((tag) => task.tagIds.contains(tag.id));
      return matchesQuery && matchesTags;
    }).toList();
  }

  /// Navigates to the subtask screen for the selected task.
  void _openTask(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubtaskScreen(task: task)
      ),
    ).then((_) => _loadTasks());
  }

  /// Opens a dialog to edit the selected task and updates Hive.
  Future<void> _editTask(Task task) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TaskForm(
            availableTags: _availableTags,
            initialTask: task,
            onSubmit: (name, tags, {description}) async {
              task.title = name;
              task.tagIds = tags.map((tag) => tag.id).toList();
              task.description = description;
              await task.save();
              await _loadTasks();
              Navigator.of(context).pop();
            },
            onDelete: () async {
              final box = Hive.box<Task>('tasks');
              await box.delete(task.key);
              await _loadTasks();
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  /// Shows a modal dialog to create a new task.
  Future<void> _showTaskFormModal() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Task'),
          content: TaskForm(
            availableTags: _availableTags,
            onSubmit: (name, tags, {description}) async {
              if (name.isNotEmpty) {
                final task = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: name,
                  tagIds: tags.map((tag) => tag.id).toList(),
                  description: description,
                );
                final box = Hive.box<Task>('tasks');
                await box.add(task);
                await _loadTasks();
              }
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  String _formatInvestedTime(Task task) {
    final totalSeconds = task.subtasks.fold(0, (sum, subtask) => sum + subtask.getTotalInvestedSeconds());
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
        onPressed: _showTaskFormModal,
      ),
      appBar: AppBar(
        leadingWidth: 60,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0),
          child: TicTaskIcon()
        ),
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar CSV',
            onPressed: () async {
              final path = await getSaveLocation(
                initialDirectory: './',
                suggestedName: 'tasks_export.csv',
                acceptedTypeGroups: [
                  XTypeGroup(label: 'CSV', extensions: ['csv']),
                ],
              );
              if (path == null) return;
              await CsvExporter.exportTasksToCsv(_filteredTasks, path.path);

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tasks exported to ${path.path}')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name or description...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 8),
            TagSelector(
              availableTags: _availableTags,
              selectedTags: _filterTags,
              onTagToggle: (tag) {
                setState(() {
                  if (_filterTags.contains(tag)) {
                    _filterTags.remove(tag);
                  } else {
                    _filterTags.add(tag);
                  }
                });
              },
              readOnly: false,
              onAddNewTag: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TagManagementScreen()),
                ).then((_) => _loadTags());
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks[index];
                  final displayTags = task.tagIds
                      .map((id) => _availableTags.firstWhere(
                            (t) => t.id == id,
                            orElse: () => Tag(
                              id: id,
                              name: id,
                              iconCodePoint: Icons.label.codePoint,
                              colorValue: Colors.grey.value,
                            ),
                          ))
                      .whereType<Tag>()
                      .toList();
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          if (task.description != null && task.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 16.0),
                              child: Text(
                                task.description!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayTags.isNotEmpty)
                            TagSelector(
                              availableTags: _availableTags,
                              selectedTags: displayTags,
                              readOnly: true,
                            ),
                          Builder(
                            builder: (context) {
                              DateTime? firstStart;
                              DateTime? lastStop;
                              for (final subtask in task.subtasks) {
                                for (final tp in subtask.timePoints) {
                                  if (tp.isStart) {
                                    if (firstStart == null || tp.timestamp.isBefore(firstStart)) {
                                      firstStart = tp.timestamp;
                                    }
                                  } else {
                                    if (lastStop == null || tp.timestamp.isAfter(lastStop)) {
                                      lastStop = tp.timestamp;
                                    }
                                  }
                                }
                              }
                              return StartEndDateRow(start: firstStart, end: lastStop);
                            },
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editTask(task),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final box = Hive.box<Task>('tasks');
                              await box.delete(task.key);
                              await _loadTasks();
                            },
                          ),
                          Text(_formatInvestedTime(task)),
                        ],
                      ),
                      onTap: () => _openTask(task),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Widget utilitário para exibir datas de início e fim formatadas
class StartEndDateRow extends StatelessWidget {
  final DateTime? start;
  final DateTime? end;
  const StartEndDateRow({super.key, this.start, this.end});

  String _format(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (start == null || end == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(_format(start), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('End', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(_format(end), style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
