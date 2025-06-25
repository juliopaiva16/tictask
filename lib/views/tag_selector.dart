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

  /// Creates a [TagSelector] widget.
  const TagSelector({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    this.onTagToggle,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 6, // Vertical spacing between lines
      children: availableTags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        final chipColor = isSelected ? tag.color.withAlpha(51) : Colors.grey[200];
        final borderColor = tag.color;
        final textColor = tag.color;
        final borderRadius = BorderRadius.circular(8); // Less rounded
        if (readOnly) {
          if (!isSelected) return const SizedBox.shrink();
          return Chip(
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
            label: Text(tag.name),
            selected: isSelected,
            selectedColor: tag.color.withAlpha(51),
            onSelected: onTagToggle != null ? (_) => onTagToggle!(tag) : null,
            backgroundColor: chipColor,
            labelStyle: TextStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
              side: BorderSide(color: borderColor),
            ),
          );
        }
      }).toList(),
    );
  }
}
