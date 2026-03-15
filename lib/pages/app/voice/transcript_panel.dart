import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../services/gemini_live_service.dart';
import '../../../widgets/transcript_view.dart';

class TranscriptPanel extends StatelessWidget {
  final List<Message> messages;
  final ScrollController scrollController;
  final LiveSessionState sessionState;
  final bool micActive;
  final bool aiSpeaking;

  const TranscriptPanel({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.sessionState,
    required this.micActive,
    required this.aiSpeaking,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        _StatusBar(
          state: sessionState,
          micActive: micActive,
          aiSpeaking: aiSpeaking,
          cs: cs,
        ),
        Expanded(
          child: TranscriptView(
            messages: messages,
            scrollController: scrollController,
            emptyLabel: sessionState == LiveSessionState.active
                ? 'Start speaking...'
                : 'Conversation will appear here',
          ),
        ),
      ],
    );
  }
}

class _StatusBar extends StatelessWidget {
  final LiveSessionState state;
  final bool micActive;
  final bool aiSpeaking;
  final ColorScheme cs;
  const _StatusBar({required this.state, required this.micActive, required this.aiSpeaking, required this.cs});

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (state) {
      LiveSessionState.connecting => ('Connecting to AI tutor...', Icons.sync, cs.secondaryContainer),
      LiveSessionState.active when aiSpeaking => ('AI is speaking...', Icons.volume_up, cs.primaryContainer),
      LiveSessionState.active when micActive => ('Listening...', Icons.graphic_eq, cs.tertiaryContainer),
      LiveSessionState.active => ('Session active — tap mic to speak', Icons.mic_none, cs.surfaceContainerHighest),
      LiveSessionState.error => ('Connection error. Try again.', Icons.error_outline, cs.errorContainer),
      _ => ('Tap Start to begin a session', Icons.mic_none, cs.surfaceContainerHighest),
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
