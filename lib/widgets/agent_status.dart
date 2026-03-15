import 'package:flutter/material.dart';

enum AgentState { idle, active, thinking, error }

class AgentStatusWidget extends StatelessWidget {
  final String agentName;
  final AgentState state;
  final String? message;

  const AgentStatusWidget({
    super.key,
    required this.agentName,
    required this.state,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (color, icon, label) = switch (state) {
      AgentState.active => (cs.primaryContainer, Icons.check_circle_outline, 'Active'),
      AgentState.thinking => (cs.secondaryContainer, Icons.psychology_outlined, 'Thinking...'),
      AgentState.error => (cs.errorContainer, Icons.error_outline, 'Error'),
      AgentState.idle => (cs.surfaceContainerHighest, Icons.circle_outlined, 'Idle'),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          state == AgentState.thinking
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: cs.secondary),
                )
              : Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(
            '$agentName · $label',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          if (message != null) ...[
            const SizedBox(width: 4),
            Text(
              '— $message',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
