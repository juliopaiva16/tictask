import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:file_selector/file_selector.dart';
import '../models/task.dart';
import '../models/subtask.dart';
import '../models/time_point.dart';
import '../models/tag.dart';
import '../viewmodels/tag_viewmodel.dart';
import '../utils/csv_exporter.dart';
import 'subtask_form.dart';
import 'tag_management_screen.dart';
/// Screen for managing subtasks of a specific task.
class SubtaskScreen extends StatefulWidget {
  /// The task whose subtasks are being managed.
  final Task task;

  /// Creates a [SubtaskScreen] for the given [task].
  const SubtaskScreen({super.key, required this.task});

  @override
  State<SubtaskScreen> createState() => _SubtaskScreenState();
}

class _SubtaskScreenState extends State<SubtaskScreen> {
  Timer? _timer;
  String _searchQuery = '';
  List<Subtask> _subtasks = [];
  List<Tag> _availableTags = [];
  final TagViewModel _tagViewModel = TagViewModel();

  /// Returns the filtered list of subtasks based on the search query.
  List<Subtask> get _filteredSubtasks {
    return _subtasks.where((subtask) {
      final matchesQuery = _searchQuery.isEmpty ||
        subtask.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (subtask.notes?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      return matchesQuery;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }
  
  Future<void> _loadData() async {
    await _loadSubtasks();
    await _loadTags();
  }

  /// Loads the subtasks for the current task from Hive.
  Future<void> _loadSubtasks() async {
    final box = Hive.box<Task>('tasks');
    final task = box.values.firstWhere((t) => t.id == widget.task.id, orElse: () => widget.task);
    setState(() {
      _subtasks = List<Subtask>.from(task.subtasks);
    });
  }
  
  /// Loads all available tags from Hive
  Future<void> _loadTags() async {
    await _tagViewModel.loadTags();
    setState(() {
      _availableTags = _tagViewModel.tags;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Deletes the given subtask from the task.
  void _deleteSubtask(Subtask subtask) async {
    final box = Hive.box<Task>('tasks');
    final task = box.values.firstWhere((t) => t.id == widget.task.id, orElse: () => widget.task);
    task.subtasks = List.from(task.subtasks)..remove(subtask);
    await task.save();
    await _loadSubtasks();
  }

  /// Toggles the play/pause state of the given subtask.
  void _togglePlayPause(Subtask subtask) async {
    final box = Hive.box<Task>('tasks');
    final task = box.values.firstWhere((t) => t.id == widget.task.id, orElse: () => widget.task);
    final isWorking = subtask.timePoints.isNotEmpty &&
        (subtask.timePoints.length % 2 == 1) &&
        subtask.timePoints.last.isStart;
    // Pause any other running subtask
    for (final s in task.subtasks) {
      if (s != subtask && s.timePoints.isNotEmpty && (s.timePoints.length % 2 == 1) && s.timePoints.last.isStart) {
        s.timePoints = List.from(s.timePoints)
          ..add(TimePoint(timestamp: DateTime.now(), isStart: false));
      }
    }
    // Toggle play/pause for the selected subtask
    subtask.timePoints = List.from(subtask.timePoints)
      ..add(TimePoint(timestamp: DateTime.now(), isStart: !isWorking));
    await task.save();
    await _loadSubtasks();
  }

  /// Shows the subtask form dialog for creating or editing a subtask.
  void _showSubtaskForm({Subtask? subtask}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(subtask == null ? 'Create Subtask' : 'Edit Subtask'),
          content: SubtaskForm(
            initialSubtask: subtask,
            availableTags: _availableTags,
            onAddNewTag: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TagManagementScreen()),
              ).then((_) => _loadTags());
            },
            onSubmit: (name, description, tags) async {
              final box = Hive.box<Task>('tasks');
              final task = box.values.firstWhere((t) => t.id == widget.task.id, orElse: () => widget.task);
              if (subtask == null) {
                final newSubtask = Subtask(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: name,
                  notes: description,
                  tagIds: tags.map((tag) => tag.id).toList(),
                );
                task.subtasks = List.from(task.subtasks)..add(newSubtask);
              } else {
                subtask.title = name;
                subtask.notes = description;
                subtask.tagIds = tags.map((tag) => tag.id).toList();
              }
              await task.save();
              await _loadSubtasks();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar subtasks em CSV',
            onPressed: () async {
              final String csvContent = CsvExporter.generateSubtasksCsv(_filteredSubtasks);
              final path = await getSaveLocation(
                initialDirectory: './',
                suggestedName: 'subtasks_${widget.task.title.replaceAll(' ', '_')}.csv',
                acceptedTypeGroups: [
                  XTypeGroup(label: 'CSV', extensions: ['csv']),
                ],
              );
              if (path == null) return;
              
              try {
                await CsvExporter.writeToFile(csvContent, path.path);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Subtasks exported to ${path.path}')),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error exporting subtasks: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search subtask by name or description',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSubtasks.length,
              separatorBuilder: (context, index) => const Divider(height: 32, thickness: 1),
              itemBuilder: (context, index) {
                final subtask = _filteredSubtasks[index];
                final isWorking = subtask.timePoints.isNotEmpty &&
                    (subtask.timePoints.length % 2 == 1) &&
                    subtask.timePoints.last.isStart;
                return ListTile(
                  leading: IconButton(
                    icon: Icon(isWorking ? Icons.pause : Icons.play_arrow),
                    onPressed: () => _togglePlayPause(subtask),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(subtask.title)),
                      Text(subtask.getFormattedInvestedTime(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subtask.notes != null && subtask.notes!.isNotEmpty)
                        Text(subtask.notes!),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 8,
                        children: [
                          for (final tp in subtask.timePoints)
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                backgroundColor: tp.isStart ? Colors.green[100] : Colors.red[100],
                                foregroundColor: tp.isStart ? Colors.green : Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: null,
                              icon: Icon(tp.isStart ? Icons.play_arrow : Icons.pause, size: 16),
                              label: Text(
                                '${tp.timestamp.year.toString().padLeft(4, '0')}-'
                                '${tp.timestamp.month.toString().padLeft(2, '0')}-'
                                '${tp.timestamp.day.toString().padLeft(2, '0')} '
                                '${tp.timestamp.hour.toString().padLeft(2, '0')}:''${tp.timestamp.minute.toString().padLeft(2, '0')}:''${tp.timestamp.second.toString().padLeft(2, '0')}',
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showSubtaskForm(subtask: subtask),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteSubtask(subtask),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Subtask'),
        onPressed: () => _showSubtaskForm(),
      ),
    );
  }
}
