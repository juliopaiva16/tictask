import 'package:hive/hive.dart';

part 'time_point.g.dart';

/// Model representing a single time point (start or stop) for a subtask.
/// Used to calculate time intervals and total invested time.
@HiveType(typeId: 1)
class TimePoint extends HiveObject {
  /// The exact date and time of the point.
  @HiveField(0)
  final DateTime timestamp;

  /// True if this point marks the start of a work interval, false if it marks the end.
  @HiveField(1)
  final bool isStart;

  /// Creates a [TimePoint] instance.
  TimePoint({required this.timestamp, required this.isStart});
}
