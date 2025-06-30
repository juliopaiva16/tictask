import 'package:flutter/material.dart';
import 'tictask_branding.dart';

class TicTaskLoadingIndicator extends StatefulWidget {
  final double size;
  final bool isDark;

  const TicTaskLoadingIndicator({
    super.key,
    this.size = 32,
    this.isDark = true,
  });

  @override
  State<TicTaskLoadingIndicator> createState() =>
      _TicTaskLoadingIndicatorState();
}

class _TicTaskLoadingIndicatorState extends State<TicTaskLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 2.0 * 3.14159,
          child: TicTaskIcon(
            width: widget.size,
            height: widget.size,
            isDark: widget.isDark,
          ),
        );
      },
    );
  }
}

class TicTaskEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionText;
  final bool isDark;

  const TicTaskEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionText,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TicTaskIcon(width: 80, height: 80, isDark: isDark),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}
