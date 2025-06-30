import 'package:flutter/material.dart';
import '../models/time_point.dart';

/// Modal for editing a TimePoint, allowing selection of date and time
class TimePointEditModal extends StatefulWidget {
  /// The timepoint to be edited
  final TimePoint timePoint;
  
  /// Callback called when the timepoint is saved
  final Function(DateTime newDateTime) onSave;
  
  const TimePointEditModal({
    super.key,
    required this.timePoint,
    required this.onSave,
  });

  @override
  State<TimePointEditModal> createState() => _TimePointEditModalState();
}

class _TimePointEditModalState extends State<TimePointEditModal> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.timePoint.timestamp;
    _selectedTime = TimeOfDay(
      hour: widget.timePoint.timestamp.hour,
      minute: widget.timePoint.timestamp.minute,
    );
  }
  
  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDate.hour,
          _selectedDate.minute,
          _selectedDate.second,
        );
      });
    }
  }
  
  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
          _selectedDate.second,
        );
      });
    }
  }
  
  void _saveTimePoint() {
    widget.onSave(_selectedDate);
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    final isStartPoint = widget.timePoint.isStart;
    final iconColor = isStartPoint ? Colors.green : Colors.red;
    final iconData = isStartPoint ? Icons.play_arrow : Icons.stop;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(iconData, color: iconColor),
          const SizedBox(width: 8),
          Text('Edit ${isStartPoint ? 'Start' : 'End'}'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current timepoint information
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Current value: ${_formatDateTime(widget.timePoint.timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          // Date selection
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date'),
            subtitle: Text('${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}'),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: _selectDate,
          ),
          
          // Time selection
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Time'),
            subtitle: Text('${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}'),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: _selectTime,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTimePoint,
          child: const Text('Save'),
        ),
      ],
    );
  }
  
  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}
