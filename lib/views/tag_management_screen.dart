import 'package:flutter/material.dart';
import '../models/tag.dart';
import '../viewmodels/tag_viewmodel.dart';
import 'tag_form.dart';

/// Screen for managing tags (create, edit, delete)
class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  State<TagManagementScreen> createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  final TagViewModel _tagViewModel = TagViewModel();
  
  @override
  void initState() {
    super.initState();
    _loadTags();
  }
  
  Future<void> _loadTags() async {
    await _tagViewModel.loadTags();
    setState(() {});
  }
  
  void _showCreateTagScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _TagFormScreen(
          onSaved: (name, icon, color) async {
            await _tagViewModel.addTag(name, icon, color);
            await _loadTags();
          },
        ),
      ),
    );
  }

  void _showEditTagScreen(Tag tag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _TagFormScreen(
          initialTag: tag,
          onSaved: (name, icon, color) async {
            await _tagViewModel.updateTag(tag, name, icon, color);
            await _loadTags();
          },
          onDeleted: () async {
            await _tagViewModel.deleteTag(tag);
            await _loadTags();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Tag tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tag'),
        content: Text('Are you sure you want to delete "${tag.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              await _tagViewModel.deleteTag(tag);
              await _loadTags();
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTagScreen,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _tagViewModel.tags.isEmpty
            ? const Center(
                child: Text(
                  'No tags yet. Tap the + button to create one.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                itemCount: _tagViewModel.tags.length,
                itemBuilder: (context, index) {
                  final tag = _tagViewModel.tags[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: tag.color,
                        child: Icon(tag.icon, color: Colors.white),
                      ),
                      title: Text(
                        tag.name,
                        style: TextStyle(
                          color: tag.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () => _showEditTagScreen(tag),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: _tagViewModel.isDefaultTag(tag) ? 'Default tags cannot be deleted' : 'Delete',
                            color: Colors.red,
                            onPressed: _tagViewModel.isDefaultTag(tag) ? null : () => _showDeleteConfirmation(tag),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

/// Internal screen to show the tag form
class _TagFormScreen extends StatelessWidget {
  final Tag? initialTag;
  final Function(String name, IconData icon, Color color) onSaved;
  final VoidCallback? onDeleted;

  const _TagFormScreen({
    this.initialTag,
    required this.onSaved,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the tag is a default tag that can't be deleted
    final TagViewModel tagViewModel = TagViewModel();
    final bool isDefaultTag = initialTag != null && tagViewModel.isDefaultTag(initialTag!);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(initialTag == null ? 'Create Tag' : 'Edit Tag'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TagForm(
          initialTag: initialTag,
          onSubmit: (name, icon, color) {
            onSaved(name, icon, color);
            Navigator.pop(context);
          },
          onDelete: onDeleted != null && !isDefaultTag ? () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Delete'),
                content: Text('Are you sure you want to delete "${initialTag!.name}"?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ) ?? false;
            
            if (confirmed) {
              onDeleted!();
              if (context.mounted) Navigator.of(context).pop();
            }
          } : null,
        ),
      ),
    );
  }
}
