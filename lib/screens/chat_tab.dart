import 'package:flutter/material.dart';

class ChatTab extends StatefulWidget {
  final String? chatId; // opsiyonel yaptık

  const ChatTab({Key? key, this.chatId}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String? currentChatId;

  @override
  void initState() {
    super.initState();
    currentChatId = widget.chatId;
    if (currentChatId == null) {
      // Buraya ilk sohbeti açma logic'i yazabilirsin.
      // Örnek: ilk sohbet id'sini al, yoksa yeni oluştur.
      currentChatId =
          'default_chat_id'; // Burayı kendi mantığına göre değiştir.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentChatId == null) {
      return const Center(child: Text('Sohbet seçilmedi'));
    }

    return Center(
      child: Text('Şu anki sohbet: $currentChatId'),
      // Buraya kendi mesajlaşma ekranını yapabilirsin.
    );
  }
}
