import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;

  const ChatScreen({super.key, required this.roomId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final chatService = ChatService();
  late final String senderId;
  late final String roomTitle;

  String _otherParticipant(String roomId, String senderId) {
    if (roomId.contains('|')) {
      final parts = roomId.split('|');
      return parts.first == senderId ? parts.last : parts.first;
    }
    return roomId;
  }

  @override
  void initState() {
    super.initState();
    senderId = AuthService().currentUserEmail ?? 'anonymous';
    if (widget.roomId == senderId) {
      roomTitle = 'My Inbox';
    } else {
      final other = _otherParticipant(widget.roomId, senderId);
      final otherName = AuthService().getAccountName(other) ?? other;
      roomTitle = otherName;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelfRoom = widget.roomId == senderId;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(roomTitle),
            const SizedBox(height: 2),
            Text(isSelfRoom ? 'You' : 'Chat room', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Map<String, String>>>(
                stream: chatService.getMessages(widget.roomId),
                initialData: const [],
                builder: (context, snapshot) {
                  final docs = snapshot.data ?? [];
                  if (docs.isEmpty) {
                    return const Center(child: Text('No messages yet. Start the conversation.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];
                      final text = data['text'] ?? '';
                      final sender = data['senderId'] ?? 'anonymous';
                      final isMe = sender == senderId;
                      return MessageBubble(text: text, isMe: isMe);
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.green[700],
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () async {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        await chatService.sendMessage(widget.roomId, senderId, text);
                        controller.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
