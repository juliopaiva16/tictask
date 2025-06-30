import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/tag.dart';

/// ViewModel for managing Tags.
/// Handles business logic and state for tag management.
class TagViewModel with ChangeNotifier {
  List<Tag> _tags = [];
  
  /// Get all tags
  List<Tag> get tags => _tags;

  /// Check if a tag is a default/built-in tag that shouldn't be deleted
  bool isDefaultTag(Tag tag) {
    // The default tags have ids from '1' to '4'
    return tag.id == '1' || tag.id == '2' || tag.id == '3' || tag.id == '4';
  }

  /// Initialize the ViewModel by loading tags from Hive
  Future<void> loadTags() async {
    final box = Hive.box<Tag>('tags');
    _tags = box.values.toList();
    notifyListeners();
  }

  /// Add a new tag to Hive and update the state
  Future<Tag> addTag(String name, IconData icon, Color color) async {
    final box = Hive.box<Tag>('tags');
    final newTag = Tag(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      iconCodePoint: icon.codePoint,
      colorValue: color.value,
    );
    
    await box.add(newTag);
    await loadTags();
    return newTag;
  }

  /// Update an existing tag
  Future<void> updateTag(Tag tag, String name, IconData icon, Color color) async {
    tag.name = name;
    tag.iconCodePoint = icon.codePoint;
    tag.colorValue = color.value;
    
    await tag.save();
    await loadTags();
  }

  /// Delete a tag from Hive and update the state
  Future<void> deleteTag(Tag tag) async {
    // Safety check: don't delete default tags
    if (isDefaultTag(tag)) {
      print('Attempted to delete a default tag: ${tag.name}');
      return;
    }
    
    final box = Hive.box<Tag>('tags');
    await box.delete(tag.key);
    await loadTags();
  }
}
