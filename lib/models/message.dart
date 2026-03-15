enum MessageRole { user, assistant }

class Message {
  final String id;
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.text,
    required this.role,
    required this.timestamp,
  });

  bool get isUser => role == MessageRole.user;

  Message copyWith({String? text}) => Message(
        id: id,
        text: text ?? this.text,
        role: role,
        timestamp: timestamp,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'role': role.name,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as String,
        text: json['text'] as String,
        role: MessageRole.values.byName(json['role'] as String),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  factory Message.user(String text) => Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: text,
        role: MessageRole.user,
        timestamp: DateTime.now(),
      );

  factory Message.assistant(String text) => Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: text,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
      );
}
