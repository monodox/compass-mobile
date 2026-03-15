import 'package:flutter/material.dart';
import '../../../services/gemini_live_service.dart';
import '../../../widgets/voice_button.dart';

class VoiceControls extends StatelessWidget {
  final LiveSessionState sessionState;
  final bool micActive;
  final bool aiSpeaking;
  final VoidCallback onToggleSession;
  final VoidCallback? onToggleMic;
  final VoidCallback? onInterrupt;

  const VoiceControls({
    super.key,
    required this.sessionState,
    required this.micActive,
    required this.aiSpeaking,
    required this.onToggleSession,
    this.onToggleMic,
    this.onInterrupt,
  });

  bool get _isActive => sessionState == LiveSessionState.active;
  bool get _isConnecting => sessionState == LiveSessionState.connecting;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        children: [
          if (onInterrupt != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: OutlinedButton.icon(
                onPressed: onInterrupt,
                icon: const Icon(Icons.pan_tool, size: 18),
                label: const Text('Interrupt'),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isActive) ...[
                _MicButton(micActive: micActive, cs: cs, onTap: onToggleMic ?? () {}),
                const SizedBox(width: 24),
              ],
              VoiceButton(
                isActive: _isActive,
                isLoading: _isConnecting,
                onTap: onToggleSession,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _isActive ? 'Session active' : 'Tap to start',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final bool micActive;
  final ColorScheme cs;
  final VoidCallback onTap;
  const _MicButton({required this.micActive, required this.cs, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = micActive ? cs.error : cs.secondary;
    return Tooltip(
      message: micActive ? 'Mute' : 'Unmute',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, spreadRadius: 1)],
          ),
          child: Icon(micActive ? Icons.mic_off : Icons.mic, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
