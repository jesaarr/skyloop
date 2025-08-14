import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatListSidebar extends StatelessWidget {
  final String? selectedChatId;
  final Function(String) onSelectChat;
  final VoidCallback onCreateNewChat;

  const ChatListSidebar({
    Key? key,
    required this.selectedChatId,
    required this.onSelectChat,
    required this.onCreateNewChat,
  }) : super(key: key);

  Stream<QuerySnapshot> _getUserChats() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection('chats')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: const Border(right: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
            child: ElevatedButton.icon(
              onPressed: onCreateNewChat,
              icon: const Icon(Icons.add),
              label: const Text('Yeni Sohbet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getUserChats(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;
                if (chats.isEmpty) {
                  return const Center(child: Text('Sohbet bulunamadı.'));
                }

                return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final chatId = chat.id;
                    final isSelected = chatId == selectedChatId;
                    final lastMessage = chat['lastMessage'] ?? '';
                    final createdAt =
                        chat['createdAt']?.toDate() ?? DateTime.now();

                    return ListTile(
                      title: Text('Sohbet ${chatId.substring(0, 6)}'),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      selected: isSelected,
                      onTap: () => onSelectChat(chatId),
                      leading: const Icon(Icons.chat_bubble_outline),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
