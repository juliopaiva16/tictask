/// Abstract base class for task items (Task/Subtask).
abstract class BaseTaskItem {
  /// Unique identifier for the item.
  final String id;
  /// Title of the item.
  String title;
  /// Optional notes or description for the item.
  String? notes;

  /// Constructor for [BaseTaskItem].
  BaseTaskItem({required this.id, required this.title, this.notes});
}
