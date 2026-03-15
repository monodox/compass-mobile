import 'message.dart';

enum SessionType { voice, text, visual }
enum SessionStatus { active, ended, paused }

class Session {
  final String id;
  final String? userId;
  final String topic;
  final SessionType type;
  SessionStatus status;
  final DateTime startedAt;
  DateTime? endedAt;
  final List<Message> messages;

  Session({
    required this.id,
    required this.topic,
    required this.type,
    this.userId,
    this.status = SessionStatus.active,
    DateTime? startedAt,
    this.endedAt,
    List<Message>? messages,
  })  : startedAt = startedAt ?? DateTime.now(),
        messages = messages ?? [];

  Duration get duration => (endedAt ?? DateTime.now()).difference(startedAt);

  String get durationLabel {
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void addMessage(Message msg) => messages.add(msg);

  void end() {
    status = SessionStatus.ended;
    endedAt = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'topic': topic,
        'type': type.name,
        'status': status.name,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt?.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory Session.create({required String topic, required SessionType type, String? userId}) =>
      Session(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        topic: topic,
        type: type,
        userId: userId,
      );
}
