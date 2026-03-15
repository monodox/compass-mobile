import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Connects the Flutter app to the Compass agents backend.
class AgentApiService {
  static String get _baseUrl =>
      dotenv.env['AGENTS_API_URL'] ?? 'http://localhost:3000';

  static final _headers = {'Content-Type': 'application/json'};

  // ── Tutor ─────────────────────────────────────────────────────────────────

  /// Ask the tutor agent to explain a concept.
  static Future<Map<String, dynamic>> explain({
    required String concept,
    String level = 'intermediate',
    String? userId,
  }) =>
      _post('/api/tutor/explain', {
        'concept': concept,
        'level': level,
        if (userId != null) 'userId': userId,
      });

  /// Get follow-up suggestions for a topic.
  static Future<Map<String, dynamic>> followUp(String topic) =>
      _post('/api/tutor/followup', {'topic': topic});

  // ── Vision ────────────────────────────────────────────────────────────────

  /// Send an image URL to the vision agent for analysis.
  static Future<Map<String, dynamic>> analyzeImage({
    required String imageUrl,
    String? context,
    String? userId,
  }) =>
      _post('/api/vision/analyze', {
        'imageUrl': imageUrl,
        if (context != null) 'context': context,
        if (userId != null) 'userId': userId,
      });

  // ── Voice ─────────────────────────────────────────────────────────────────

  /// Send a voice transcript to the voice agent.
  static Future<Map<String, dynamic>> sendTranscript({
    required String transcript,
    String? sessionId,
  }) =>
      _post('/api/voice/transcript', {
        'transcript': transcript,
        if (sessionId != null) 'sessionId': sessionId,
      });

  /// Get the Gemini Live WebSocket config from the backend.
  static Future<Map<String, dynamic>> getLiveConfig() => _get('/api/voice/live-config');

  // ── Router ────────────────────────────────────────────────────────────────

  /// Auto-route an intent to the best agent.
  static Future<Map<String, dynamic>> route(String intent) =>
      _post('/api/route', {'intent': intent});

  // ── Health ────────────────────────────────────────────────────────────────

  static Future<bool> isHealthy() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/health'));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: _headers,
        body: jsonEncode(body),
      );
      return _parse(res);
    } catch (e) {
      debugPrint('[AgentApiService] POST $path error: $e');
      return {'error': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> _get(String path) async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl$path'), headers: _headers);
      return _parse(res);
    } catch (e) {
      debugPrint('[AgentApiService] GET $path error: $e');
      return {'error': e.toString()};
    }
  }

  static Map<String, dynamic> _parse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    return {'error': 'HTTP ${res.statusCode}', 'body': res.body};
  }
}
