import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

enum LiveSessionState { idle, connecting, active, error }

class TranscriptEntry {
  final String text;
  final bool isUser;
  TranscriptEntry({required this.text, required this.isUser});
}

class GeminiLiveService {
  static const _model = 'models/gemini-2.0-flash-live-001';
  static const _baseUrl =
      'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContent';

  final String apiKey;
  final String systemInstruction;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;

  final _stateCtrl = StreamController<LiveSessionState>.broadcast();
  final _transcriptCtrl = StreamController<TranscriptEntry>.broadcast();
  final _audioCtrl = StreamController<List<int>>.broadcast();

  Stream<LiveSessionState> get stateStream => _stateCtrl.stream;
  Stream<TranscriptEntry> get transcriptStream => _transcriptCtrl.stream;
  Stream<List<int>> get audioStream => _audioCtrl.stream;

  LiveSessionState _state = LiveSessionState.idle;
  LiveSessionState get state => _state;

  GeminiLiveService({required this.apiKey, required this.systemInstruction});

  Future<void> connect() async {
    _setState(LiveSessionState.connecting);
    try {
      final uri = Uri.parse('$_baseUrl?key=$apiKey');
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      // Send setup
      _channel!.sink.add(jsonEncode({
        'setup': {
          'model': _model,
          'generation_config': {
            'response_modalities': ['AUDIO', 'TEXT'],
            'speech_config': {
              'voice_config': {
                'prebuilt_voice_config': {'voice_name': 'Aoede'}
              }
            }
          },
          'system_instruction': {
            'parts': [{'text': systemInstruction}]
          }
        }
      }));

      _sub = _channel!.stream.listen(
        _onMessage,
        onError: (e) => _setState(LiveSessionState.error),
        onDone: () => _setState(LiveSessionState.idle),
      );

      _setState(LiveSessionState.active);
    } catch (e) {
      _setState(LiveSessionState.error);
    }
  }

  void sendAudioChunk(List<int> pcmBytes) {
    if (_state != LiveSessionState.active) return;
    _channel?.sink.add(jsonEncode({
      'realtime_input': {
        'media_chunks': [
          {'mime_type': 'audio/pcm', 'data': base64Encode(pcmBytes)}
        ]
      }
    }));
  }

  void sendText(String text) {
    if (_state != LiveSessionState.active) return;
    _transcriptCtrl.add(TranscriptEntry(text: text, isUser: true));
    _channel?.sink.add(jsonEncode({
      'client_content': {
        'turns': [
          {
            'role': 'user',
            'parts': [{'text': text}]
          }
        ],
        'turn_complete': true
      }
    }));
  }

  void interrupt() {
    if (_state != LiveSessionState.active) return;
    _channel?.sink.add(jsonEncode({'client_content': {'turn_complete': false}}));
  }

  void _onMessage(dynamic raw) {
    try {
      final data = jsonDecode(raw as String) as Map<String, dynamic>;

      // Setup complete
      if (data.containsKey('setupComplete')) return;

      final serverContent = data['serverContent'] as Map<String, dynamic>?;
      if (serverContent == null) return;

      final parts = (serverContent['modelTurn']?['parts'] as List?) ?? [];
      for (final part in parts) {
        // Audio response
        final inlineData = part['inlineData'] as Map<String, dynamic>?;
        if (inlineData != null) {
          final bytes = base64Decode(inlineData['data'] as String);
          _audioCtrl.add(bytes);
        }
        // Text / transcript
        final text = part['text'] as String?;
        if (text != null && text.trim().isNotEmpty) {
          _transcriptCtrl.add(TranscriptEntry(text: text, isUser: false));
        }
      }

      // Input transcription (user speech → text)
      final inputTranscription = serverContent['inputTranscription'] as Map?;
      final userText = inputTranscription?['text'] as String?;
      if (userText != null && userText.trim().isNotEmpty) {
        _transcriptCtrl.add(TranscriptEntry(text: userText, isUser: true));
      }
    } catch (_) {}
  }

  void _setState(LiveSessionState s) {
    _state = s;
    _stateCtrl.add(s);
  }

  Future<void> disconnect() async {
    await _sub?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _setState(LiveSessionState.idle);
  }

  void dispose() {
    disconnect();
    _stateCtrl.close();
    _transcriptCtrl.close();
    _audioCtrl.close();
  }
}
