import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Bunu unutma

import 'chat_list_sidebar.dart';
import 'chat_tab.dart';

class HomeChatScreen extends StatefulWidget {
  const HomeChatScreen({Key? key}) : super(key: key);

  @override
  State<HomeChatScreen> createState() => _HomeChatScreenState();
}

class _HomeChatScreenState extends State<HomeChatScreen> {
  String? selectedChatId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initFirstChat();
  }

  Future<void> _initFirstChat() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        final newChatDoc = await FirebaseFirestore.instance
            .collection('chats')
            .add({
              'userId': userId,
              'createdAt': DateTime.now(),
              'lastMessage': '',
              'lastMessageAt': null,
            });
        selectedChatId = newChatDoc.id;
      } else {
        selectedChatId = snapshot.docs.first.id;
      }
    } catch (e) {
      debugPrint('Firestore hata: $e');
      // Burada hata mesajı gösterebilirsin
    }

    setState(() {
      _loading = false;
    });
  }

  void _createNewChat() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final newChatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .add({
            'userId': userId,
            'createdAt': DateTime.now(),
            'lastMessage': '',
            'lastMessageAt': null,
          });

      setState(() {
        selectedChatId = newChatDoc.id;
      });
    } catch (e) {
      debugPrint('Yeni sohbet oluşturma hatası: $e');
    }
  }

  void _selectChat(String chatId) {
    setState(() {
      selectedChatId = chatId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Row(
        children: [
          ChatListSidebar(
            selectedChatId: selectedChatId,
            onSelectChat: _selectChat,
            onCreateNewChat: _createNewChat,
          ),
          Expanded(
            child: selectedChatId == null
                ? const Center(child: Text('Bir sohbet seçin'))
                : ChatTab(chatId: selectedChatId!),
          ),
        ],
      ),
    );
  }
}
