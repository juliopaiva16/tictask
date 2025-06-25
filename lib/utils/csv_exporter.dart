import 'dart:io';
import 'package:csv/csv.dart';
import '../models/task.dart';
import '../models/subtask.dart';

class CsvExporter {
  /// Exports all tasks to a CSV file
  static Future<String> exportTasksToCsv(List<Task> tasks, String filePath) async {
    final List<List<dynamic>> rows = [
      [
        'ID',
        'Title',
        'Description',
        'Status',
        'Total Time (hh:mm:ss)',
        'Start Date',
        'End Date',
      ],
      ...tasks.map((task) {
        final investedSeconds = task.subtasks.fold(0, (sum, subtask) => sum + subtask.getTotalInvestedSeconds());
        final investedStr = '${investedSeconds ~/ 3600}h '
            '${((investedSeconds % 3600) ~/ 60).toString().padLeft(2, '0')}m '
            '${(investedSeconds % 60).toString().padLeft(2, '0')}s';
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
        String formatDate(DateTime? dt) {
          if (dt == null) return '';
          return '${dt.day.toString().padLeft(2, '0')}/'
                 '${dt.month.toString().padLeft(2, '0')}/'
                 '${dt.year} '
                 '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
        }
        return [
          task.id,
          task.title,
          task.description ?? '',
          task.status,
          investedStr,
          formatDate(firstStart),
          formatDate(lastStop),
        ];
      })
    ];
    String csv = const ListToCsvConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csv);
    return file.path;
  }

  /// Exports all subtasks of a task to a CSV file
  static Future<String> exportSubtasksToCsv(List<Subtask> subtasks, String filePath) async {
    final List<List<dynamic>> rows = [
      [
        'ID',
        'Title',
        'Notes',
        'Invested Time (hh:mm:ss)',
        'Start Date',
        'End Date',
      ],
      ...subtasks.map((subtask) {
        final invested = subtask.getFormattedInvestedTime();
        final firstStart = subtask.timePoints
            .where((tp) => tp.isStart)
            .map((tp) => tp.timestamp)
            .fold<DateTime?>(null, (prev, ts) => prev == null || ts.isBefore(prev) ? ts : prev);
        final lastStop = subtask.timePoints
            .where((tp) => !tp.isStart)
            .map((tp) => tp.timestamp)
            .fold<DateTime?>(null, (prev, ts) => prev == null || ts.isAfter(prev) ? ts : prev);
        String formatDate(DateTime? dt) {
          if (dt == null) return '';
          return '${dt.day.toString().padLeft(2, '0')}/'
                 '${dt.month.toString().padLeft(2, '0')}/'
                 '${dt.year} '
                 '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
        }
        return [
          subtask.id,
          subtask.title,
          subtask.notes ?? '',
          invested,
          formatDate(firstStart),
          formatDate(lastStop),
        ];
      })
    ];
    String csv = const ListToCsvConverter().convert(rows);
    final file = File(filePath);
    await file.writeAsString(csv);
    return file.path;
  }
}
