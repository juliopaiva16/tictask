import '../models/subtask.dart';
import '../models/time_point.dart';
import 'task_time_mixin.dart';

/// ViewModel for managing a Subtask and its time points.
/// Handles business logic and state for the Subtask view.
class SubtaskViewModel with TaskTimeMixin<Subtask> {
  /// The subtask being managed.
  Subtask subtask;

  /// Creates a [SubtaskViewModel] for the given [subtask].
  SubtaskViewModel({required this.subtask});

  /// Registers a start or stop time point for the subtask.
  void addTimePoint(DateTime timestamp, bool isStart) {
    subtask.timePoints = List.from(subtask.timePoints)
      ..add(TimePoint(timestamp: timestamp, isStart: isStart));
  }

  /// Gets the total invested time for the subtask (in minutes).
  @override
  int get totalInvestedMinutes => subtask.getTotalInvestedSeconds() ~/ 60;
}
