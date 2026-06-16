import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/chat_service.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final userEmail = auth.currentUserEmail;
    final userName = auth.currentUserName;
    final currentEmail = userEmail;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Chat App'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.green[600],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green[800],
                  child: Text(
                    userName != null && userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? 'New User',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userEmail ?? 'No email provided',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Chats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                if (userEmail != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Contacts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[800]),
                    ),
                  ),
                  ...auth.getOtherAccounts(currentEmail!).map((account) {
                    final email = account['email'] ?? '';
                    final name = account['name'] ?? email;
                    final roomId = ChatService.conversationId(currentEmail, email);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(name),
                        subtitle: Text(email),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(roomId: roomId)));
                        },
                      ),
                    );
                  }),
                  if (auth.getOtherAccounts(userEmail).isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('No other accounts yet. Register another account to chat.')),
                    ),
                ],
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[400],
                      child: Text(
                        userName != null && userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: const Text('My Inbox'),
                    subtitle: const Text('Private chat with yourself'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(roomId: currentEmail!)));
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.person_add, color: Colors.white),
                    ),
                    title: const Text('Register a new account'),
                    subtitle: const Text('Create another user to chat with'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
