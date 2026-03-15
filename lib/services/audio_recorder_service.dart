import 'dart:async';
import 'dart:typed_data';
import 'package:record/record.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _sub;

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> start(void Function(List<int> pcmChunk) onChunk) async {
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );
    _sub = stream.listen(onChunk);
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    await _recorder.stop();
  }

  void dispose() {
    stop();
    _recorder.dispose();
  }
}
