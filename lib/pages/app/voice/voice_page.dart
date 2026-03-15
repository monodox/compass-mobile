import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import '../../../models/message.dart';
import '../../../models/conversation.dart';
import '../../../models/session.dart';
import '../../../services/gemini_live_service.dart';
import '../../../services/audio_recorder_service.dart';
import 'transcript_panel.dart';
import 'voice_controls.dart';

class VoicePage extends StatefulWidget {
  const VoicePage({super.key});

  @override
  State<VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends State<VoicePage> {
  late final GeminiLiveService _live;
  final _recorder = AudioRecorderService();
  final _player = AudioPlayer();
  final _scrollCtrl = ScrollController();

  late final Conversation _conversation;

  LiveSessionState _sessionState = LiveSessionState.idle;
  bool _micActive = false;
  bool _aiSpeaking = false;
  final _stopwatch = Stopwatch();
  int _elapsed = 0;
  Timer? _timer;

  StreamSubscription? _stateSub;
  StreamSubscription? _transcriptSub;
  StreamSubscription? _audioSub;

  @override
  void initState() {
    super.initState();
    _conversation = Conversation.start(topic: 'Voice Session', type: SessionType.voice);

    _live = GeminiLiveService(
      apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      systemInstruction:
          'You are ThinkLab, an expert AI tutor. Explain complex scientific concepts clearly and concisely. Adapt your explanations to the user\'s level. Be conversational and encouraging.',
    );

    _stateSub = _live.stateStream.listen((s) {
      if (mounted) setState(() => _sessionState = s);
    });

    _transcriptSub = _live.transcriptStream.listen((entry) {
      if (!mounted) return;
      setState(() {
        if (entry.isUser) {
          _conversation.addUserMessage(entry.text);
        } else {
          _conversation.addAssistantMessage(entry.text);
          _aiSpeaking = true;
        }
      });
      _scrollToBottom();
    });

    _audioSub = _live.audioStream.listen((_) {
      if (mounted) setState(() => _aiSpeaking = true);
    });
  }

  Future<void> _toggleSession() async {
    if (_sessionState == LiveSessionState.active) {
      await _stopSession();
    } else {
      await _startSession();
    }
  }

  Future<void> _startSession() async {
    if (!await _recorder.hasPermission()) {
      _showSnack('Microphone permission required');
      return;
    }
    await _live.connect();
    await _recorder.start(_live.sendAudioChunk);
    setState(() => _micActive = true);
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed = _stopwatch.elapsed.inSeconds);
    });
  }

  Future<void> _stopSession() async {
    _timer?.cancel();
    _stopwatch.stop();
    await _recorder.stop();
    await _live.disconnect();
    _conversation.session.end();
    if (mounted) setState(() { _micActive = false; _aiSpeaking = false; _elapsed = 0; });
  }

  Future<void> _toggleMic() async {
    if (_micActive) {
      await _recorder.stop();
      setState(() => _micActive = false);
    } else {
      await _recorder.start(_live.sendAudioChunk);
      setState(() => _micActive = true);
    }
  }

  void _interrupt() {
    _live.interrupt();
    setState(() => _aiSpeaking = false);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  String get _timerLabel {
    final m = (_elapsed ~/ 60).toString().padLeft(2, '0');
    final s = (_elapsed % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stateSub?.cancel();
    _transcriptSub?.cancel();
    _audioSub?.cancel();
    _recorder.dispose();
    _player.dispose();
    _live.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = _sessionState == LiveSessionState.active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Lab'),
        actions: [
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Chip(
                avatar: const Icon(Icons.timer_outlined, size: 16),
                label: Text(_timerLabel),
                backgroundColor: cs.errorContainer,
                labelStyle: TextStyle(color: cs.onErrorContainer),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TranscriptPanel(
              messages: _conversation.messages.cast<Message>(),
              scrollController: _scrollCtrl,
              sessionState: _sessionState,
              micActive: _micActive,
              aiSpeaking: _aiSpeaking,
            ),
          ),
          VoiceControls(
            sessionState: _sessionState,
            micActive: _micActive,
            aiSpeaking: _aiSpeaking,
            onToggleSession: _toggleSession,
            onToggleMic: isActive ? _toggleMic : null,
            onInterrupt: _aiSpeaking ? _interrupt : null,
          ),
        ],
      ),
    );
  }
}
