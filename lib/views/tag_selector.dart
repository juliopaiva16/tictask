import 'package:flutter/material.dart';
import '../models/tag.dart';

/// Reusable widget for selecting tags.
class TagSelector extends StatelessWidget {
  /// List of all available tags.
  final List<Tag> availableTags;

  /// Set of currently selected tags.
  final List<Tag> selectedTags;

  /// Callback when a tag is toggled (selected/deselected).
  final void Function(Tag tag)? onTagToggle;

  /// If true, the widget is read-only and only displays selected tags.
  final bool readOnly;

  /// Callback when the "Add New Tag" button is pressed.
  final VoidCallback? onAddNewTag;

  /// Creates a [TagSelector] widget.
  const TagSelector({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    this.onTagToggle,
    this.readOnly = false,
    this.onAddNewTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 6, // Vertical spacing between lines
          children: [
            // Add New Tag button
            if (!readOnly && onAddNewTag != null)
              ActionChip(
                avatar: Icon(
                  Icons.add,
                  size: 16,
                  color: Colors.grey[500],
                ),
                label: const Text('New Label'),
                onPressed: onAddNewTag,
                backgroundColor: Colors.grey[500]!.withAlpha(30),
                labelStyle: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[500]!),
                ),
              ),
            ...availableTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              final chipColor = isSelected
                  ? tag.color.withAlpha(100)
                  : tag.color.withAlpha(30);
              final borderColor = tag.color;
              final textColor = tag.color;
              final borderRadius = BorderRadius.circular(8); // Less rounded
              if (readOnly) {
                if (!isSelected) return const SizedBox.shrink();
                return Chip(
                  avatar: Icon(tag.icon, size: 16, color: textColor),
                  label: Text(
                    tag.name,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: chipColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                    side: BorderSide(color: borderColor),
                  ),
                );
              } else {
                return ChoiceChip(
                  avatar: Icon(tag.icon, size: 16, color: textColor),
                  label: Text(tag.name),
                  selected: isSelected,
                  selectedColor: tag.color.withAlpha(51),
                  onSelected: onTagToggle != null
                      ? (_) => onTagToggle!(tag)
                      : null,
                  backgroundColor: chipColor,
                  labelStyle: TextStyle(
                    color: textColor,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius,
                    side: BorderSide(color: borderColor),
                  ),
                );
              }
            }),
          ],
        ),
      ],
    );
  }
}
