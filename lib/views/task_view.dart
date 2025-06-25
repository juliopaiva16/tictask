import 'package:flutter/material.dart';
import '../models/subtask.dart';
import '../viewmodels/task_viewmodel.dart';
import '../viewmodels/subtask_viewmodel.dart';
import 'subtask_view.dart';

/// A view for managing a Task and its Subtasks.
/// Allows the user to add new subtasks and see the total invested time for the task.
class TaskView extends StatefulWidget {
  final TaskViewModel viewModel;

  const TaskView({super.key, required this.viewModel});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController _subtaskController = TextEditingController();

  void _addSubtask() {
    final title = _subtaskController.text.trim();
    if (title.isNotEmpty) {
      final subtask = Subtask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
      );
      setState(() {
        widget.viewModel.addSubtask(subtask);
        _subtaskController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final invested = widget.viewModel.totalInvestedMinutes;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.task.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total invested time: $invested minutes', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subtaskController,
                    decoration: const InputDecoration(
                      labelText: 'New Subtask',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addSubtask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: widget.viewModel.task.subtasks
                    .map((subtask) => SubtaskView(
                          viewModel: SubtaskViewModel(subtask: subtask),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

