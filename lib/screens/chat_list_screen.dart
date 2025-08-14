import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatListScreen extends StatelessWidget {
  final Function(String) onSelectChat;

  ChatListScreen({Key? key, required this.onSelectChat}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sohbetler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newChatId = await _chatService.createNewChat(userId);
              onSelectChat(newChatId);
              Navigator.pop(context); // Listeyi kapat, sohbete dön
            },
            tooltip: 'Yeni Sohbet Oluştur',
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _chatService.getChats(userId),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final chats = snapshot.data.docs;

          if (chats.isEmpty) {
            return const Center(
              child: Text('Henüz sohbet yok, yeni sohbet başlat!'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chatId = chatDoc.id;
              final lastMessageAt = chatDoc['lastMessageAt'] as Timestamp?;
              final lastMsgDate = lastMessageAt?.toDate() ?? DateTime.now();

              return ListTile(
                title: Text('Sohbet $chatId'),
                subtitle: Text('Son: ${lastMsgDate.toLocal()}'),
                leading: const Icon(Icons.chat_bubble_outline),
                onTap: () {
                  onSelectChat(chatId);
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
    );
  }
}
