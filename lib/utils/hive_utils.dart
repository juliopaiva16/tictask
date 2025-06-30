import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;

/// Utility class for managing Hive database operations
class HiveUtils {
  /// Clears all Hive database boxes
  static Future<void> clearAllBoxes() async {
    await Hive.deleteBoxFromDisk('tasks');
    await Hive.deleteBoxFromDisk('tags');
    print('All Hive boxes have been cleared.');
  }

  /// Deletes the entire Hive database folder
  static Future<void> deleteHiveFolder() async {
    final hivePath = Platform.isMacOS || Platform.isLinux || Platform.isWindows
        ? './hive'
        : 'hive';

    final directory = Directory(hivePath);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
      print('Hive folder deleted successfully.');
    } else {
      print('Hive folder does not exist.');
    }
  }

  /// Backs up the Hive database
  static Future<void> backupHiveDatabase() async {
    final hivePath = Platform.isMacOS || Platform.isLinux || Platform.isWindows
        ? './hive'
        : 'hive';

    final backupPath =
        '${hivePath}_backup_${DateTime.now().millisecondsSinceEpoch}';

    final directory = Directory(hivePath);
    if (await directory.exists()) {
      final backupDir = Directory(backupPath);
      await _copyDirectory(directory, backupDir);
      print('Hive database backed up to $backupPath');
    } else {
      print('Hive folder does not exist, no backup created.');
    }
  }

  static Future<void> _copyDirectory(
    Directory source,
    Directory destination,
  ) async {
    await destination.create(recursive: true);

    await for (var entity in source.list(recursive: false)) {
      if (entity is Directory) {
        final newDirectory = Directory(
          path.join(destination.path, path.basename(entity.path)),
        );
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        await entity.copy(
          path.join(destination.path, path.basename(entity.path)),
        );
      }
    }
  }
}
