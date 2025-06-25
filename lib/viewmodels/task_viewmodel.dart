import '../models/task.dart';
import '../models/subtask.dart';
import '../models/tag.dart';
import 'task_time_mixin.dart';

/// ViewModel for managing a Task and its associated Subtasks.
/// Handles business logic and state for the Task view.
class TaskViewModel with TaskTimeMixin<Task> {
  /// The task being managed.
  Task task;

  TaskViewModel({required this.task});

  /// Adds a new subtask to the task.
  void addSubtask(Subtask subtask) {
    task.subtasks = List.from(task.subtasks)..add(subtask);
  }

  /// Removes a subtask by its id.
  void removeSubtask(String subtaskId) {
    task.subtasks = task.subtasks.where((s) => s.id != subtaskId).toList();
  }

  /// Gets the total invested time for the task (in minutes).
  @override
  int get totalInvestedMinutes => task.getTotalInvestedMinutes();

  /// Adds a tag to the task if not already present.
  void addTag(Tag tag) {
    if (!task.tagIds.contains(tag.id)) {
      task.tagIds = List.from(task.tagIds)..add(tag.id);
    }
  }

  /// Removes a tag from the task by its id.
  void removeTag(String tagId) {
    task.tagIds.removeWhere((id) => id == tagId);
  }
}
