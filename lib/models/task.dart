import 'package:hive/hive.dart';
import 'subtask.dart';

part 'task.g.dart';

/// Model representing a main task, which can have multiple associated subtasks.
@HiveType(typeId: 3)
class Task extends HiveObject {
  /// Unique identifier for the task.
  @HiveField(0)
  String id;

  /// Title of the task.
  @HiveField(1)
  String title;

  /// List of subtasks associated with this task.
  @HiveField(2)
  List<Subtask> subtasks;

  /// Status of the task (e.g., Not Started, In Progress, Completed).
  @HiveField(3)
  String status;

  /// List of ids das tags atribuídas a esta task.
  @HiveField(4)
  List<String> tagIds;

  /// Optional description for the task.
  @HiveField(5)
  String? description;

  /// Creates a [Task] instance.
  Task({
    required this.id,
    required this.title,
    this.subtasks = const [],
    this.status = 'Not Started',
    this.tagIds = const [],
    this.description,
  });

  /// Calculates the total invested time in this task (sum of all subtasks) in minutes.
  int getTotalInvestedMinutes() {
    return subtasks.fold(
          0,
          (sum, subtask) => sum + subtask.getTotalInvestedSeconds(),
        ) ~/
        60;
  }
}
