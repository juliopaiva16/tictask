import 'package:hive/hive.dart';
import 'time_point.dart';

part 'subtask.g.dart';

/// Model representing a subtask associated with a main task.
@HiveType(typeId: 2)
class Subtask extends HiveObject {
  /// Unique identifier for the subtask.
  @HiveField(0)
  String id;

  /// Title of the subtask.
  @HiveField(1)
  String title;

  /// List of time points (start/stop) for this subtask.
  @HiveField(2)
  List<TimePoint> timePoints;

  /// Optional notes or description for the subtask.
  @HiveField(3)
  String? notes;

  /// Creates a [Subtask] instance.
  Subtask({
    required this.id,
    required this.title,
    this.timePoints = const [],
    this.notes,
  });

  /// Calculates the total invested time in this subtask in seconds.
  int getTotalInvestedSeconds() {
    int total = 0;
    for (int i = 0; i < timePoints.length; i += 2) {
      final start = timePoints[i];
      DateTime? endTime;
      if (i + 1 < timePoints.length) {
        final end = timePoints[i + 1];
        if (start.isStart && !end.isStart) {
          endTime = end.timestamp;
        }
      } else if (start.isStart) {
        endTime = DateTime.now();
      }
      if (endTime != null) {
        total += endTime.difference(start.timestamp).inSeconds;
      }
    }
    return total;
  }

  /// Returns a formatted string of the invested time as HH:mm:ss.
  String getFormattedInvestedTime() {
    final seconds = getTotalInvestedSeconds();
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
