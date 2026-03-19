import 'package:flutter/material.dart';

enum StatusType { loading, success, error }

class StatusWidgetFactory {
  const StatusWidgetFactory._();

  static Widget create(StatusType type, {required String message}) {
    return switch (type) {
      StatusType.loading => _StatusCard(
        icon: Icons.hourglass_top_rounded,
        color: Colors.amber.shade700,
        title: 'Loading',
        message: message,
      ),
      StatusType.success => _StatusCard(
        icon: Icons.check_circle_rounded,
        color: Colors.green.shade700,
        title: 'Success',
        message: message,
      ),
      StatusType.error => _StatusCard(
        icon: Icons.error_rounded,
        color: Colors.red.shade700,
        title: 'Error',
        message: message,
      ),
    };
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
