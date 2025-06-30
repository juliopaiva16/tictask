import 'package:flutter/material.dart';
import '../viewmodels/subtask_viewmodel.dart';

/// A simple view for managing a Subtask.
/// Allows the user to add start/stop time points and shows total invested time.
class SubtaskView extends StatefulWidget {
  /// The view model for the subtask being managed.
  final SubtaskViewModel viewModel;

  /// Creates a [SubtaskView] for the given [viewModel].
  const SubtaskView({super.key, required this.viewModel});

  @override
  State<SubtaskView> createState() => _SubtaskViewState();
}

class _SubtaskViewState extends State<SubtaskView> {
  bool _isWorking = false;

  /// Toggles the working state and adds a time point.
  void _toggleWork() {
    final now = DateTime.now();
    setState(() {
      widget.viewModel.addTimePoint(now, !_isWorking);
      _isWorking = !_isWorking;
    });
  }

  @override
  Widget build(BuildContext context) {
    final invested = widget.viewModel.subtask.getFormattedInvestedTime();
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.viewModel.subtask.title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Text('Total invested time: $invested'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _toggleWork,
              child: Text(_isWorking ? 'Stop' : 'Start'),
            ),
            const SizedBox(height: 16),
            Text('Time points:'),
            ...widget.viewModel.subtask.timePoints.map(
              (tp) => Text(
                '${tp.isStart ? 'Start' : 'Stop'}: '
                '${tp.timestamp.year.toString().padLeft(4, '0')}-'
                '${tp.timestamp.month.toString().padLeft(2, '0')}-'
                '${tp.timestamp.day.toString().padLeft(2, '0')} '
                '${tp.timestamp.hour.toString().padLeft(2, '0')}:'
                '${tp.timestamp.minute.toString().padLeft(2, '0')}:'
                '${tp.timestamp.second.toString().padLeft(2, '0')}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
