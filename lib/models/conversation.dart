import 'message.dart';
import 'session.dart';

class Conversation {
  final Session session;
  final List<Message> _messages;

  Conversation({required this.session}) : _messages = session.messages;

  List<Message> get messages => List.unmodifiable(_messages);
  int get messageCount => _messages.length;
  bool get isEmpty => _messages.isEmpty;

  Message addUserMessage(String text) {
    final msg = Message.user(text);
    _messages.add(msg);
    session.addMessage(msg);
    return msg;
  }

  Message addAssistantMessage(String text) {
    final msg = Message.assistant(text);
    _messages.add(msg);
    session.addMessage(msg);
    return msg;
  }

  List<Map<String, dynamic>> toApiHistory() => _messages
      .map((m) => {'role': m.isUser ? 'user' : 'model', 'parts': [{'text': m.text}]})
      .toList();

  factory Conversation.start({required String topic, required SessionType type, String? userId}) =>
      Conversation(
        session: Session.create(topic: topic, type: type, userId: userId),
      );
}
