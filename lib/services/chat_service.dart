import 'dart:async';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final Map<String, List<Map<String, String>>> _messages = {};
  final Map<String, StreamController<List<Map<String, String>>>> _controllers = {};

  static String conversationId(String emailA, String emailB) {
    final participants = [emailA, emailB]..sort();
    return participants.join('|');
  }

  Stream<List<Map<String, String>>> getMessages(String roomId) {
    _messages.putIfAbsent(roomId, () => []);
    if (!_controllers.containsKey(roomId)) {
      _controllers[roomId] = StreamController<List<Map<String, String>>>.broadcast(
        onListen: () {
          _controllers[roomId]!.add(List<Map<String, String>>.from(_messages[roomId]!));
        },
      );
    }
    return _controllers[roomId]!.stream;
  }

  Future<void> sendMessage(String roomId, String senderId, String text) async {
    final message = {'senderId': senderId, 'text': text};

    _messages.putIfAbsent(roomId, () => []);
    _messages[roomId]!.add(message);
    _controllers.putIfAbsent(
      roomId,
      () => StreamController<List<Map<String, String>>>.broadcast(
        onListen: () {
          _controllers[roomId]!.add(List<Map<String, String>>.from(_messages[roomId]!));
        },
      ),
    );
    _controllers[roomId]!.add(List<Map<String, String>>.from(_messages[roomId]!));
  }
}
