import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'tag.g.dart';

/// Model representing a tag that can be assigned to a task.
@HiveType(typeId: 0)
class Tag extends HiveObject {
  /// Unique identifier for the tag.
  @HiveField(0)
  String id;

  /// Name of the tag.
  @HiveField(1)
  String name;

  /// Icon code point for the tag (Flutter built-in icons).
  @HiveField(2)
  int iconCodePoint;

  /// Color value of the tag.
  @HiveField(3)
  int colorValue;

  /// Main constructor for [Tag].
  Tag({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
  });

  /// Returns the [IconData] for this tag.
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  /// Returns the [Color] for this tag.
  Color get color => Color(colorValue);

  @override
  String toString() => 'Tag(name: $name, id: $id)';
}
