import 'package:flutter/material.dart';

class VoiceButton extends StatelessWidget {
  final bool isActive;
  final bool isLoading;
  final VoidCallback onTap;
  final double size;

  const VoiceButton({
    super.key,
    required this.isActive,
    required this.onTap,
    this.isLoading = false,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = isActive ? cs.error : cs.primary;

    return Tooltip(
      message: isActive ? 'End session' : 'Start session',
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(isActive ? 0.5 : 0.3),
                blurRadius: isActive ? 20 : 10,
                spreadRadius: isActive ? 4 : 1,
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                )
              : Icon(
                  isActive ? Icons.call_end : Icons.call,
                  color: Colors.white,
                  size: size * 0.42,
                ),
        ),
      ),
    );
  }
}
