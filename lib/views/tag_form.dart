import 'package:flutter/material.dart';
import '../models/tag.dart';
import 'custom_text_field.dart';

/// A reusable form widget for creating or editing a Tag.
class TagForm extends StatefulWidget {
  final Tag? initialTag;
  final void Function(String name, IconData icon, Color color) onSubmit;
  final void Function()? onDelete;

  const TagForm({
    super.key,
    this.initialTag,
    required this.onSubmit,
    this.onDelete,
  });

  @override
  State<TagForm> createState() => _TagFormState();
}

class _TagFormState extends State<TagForm> {
  late TextEditingController _nameController;
  late Color _selectedColor;
  late IconData _selectedIcon;

  // List of common icons to choose from
  final List<IconData> _availableIcons = [
    Icons.work,
    Icons.home,
    Icons.code,
    Icons.school,
    Icons.sports,
    Icons.star,
    Icons.favorite,
    Icons.book,
    Icons.people,
    Icons.search,
    Icons.bug_report,
    Icons.alarm,
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.fitness_center,
    Icons.music_note,
    Icons.movie,
    Icons.laptop,
    Icons.travel_explore,
    Icons.health_and_safety,
  ];

  // List of colors to choose from
  final List<Color> _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTag?.name ?? '');
    _selectedColor = widget.initialTag != null 
        ? widget.initialTag!.color 
        : _availableColors[0];
    _selectedIcon = widget.initialTag != null 
        ? widget.initialTag!.icon 
        : _availableIcons[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Tag name',
          ),
          const SizedBox(height: 16),
          const Text('Select Color', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _availableColors.map((color) {
                  final isSelected = color.value == _selectedColor.value;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: isSelected 
                        ? const Icon(Icons.check, color: Colors.white) 
                        : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Select Icon', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = icon.codePoint == _selectedIcon.codePoint;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? _selectedColor.withOpacity(0.2) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? _selectedColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon, 
                        color: isSelected ? _selectedColor : Colors.grey[600],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onDelete != null)
                TextButton(
                  onPressed: widget.onDelete,
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    widget.onSubmit(
                      _nameController.text.trim(),
                      _selectedIcon,
                      _selectedColor,
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
