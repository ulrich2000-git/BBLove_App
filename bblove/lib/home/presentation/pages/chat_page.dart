import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': 'Sarah',
        'last': 'You escaped me…',
        'time': '8:41',
        'image': 'https://randomuser.me/api/portraits/women/65.jpg'
      },
      {
        'name': 'John',
        'last': 'Needings you me...',
        'time': '8:15',
        'image': 'https://randomuser.me/api/portraits/men/43.jpg'
      },
      {
        'name': 'Emily',
        'last': 'Hello! available?',
        'time': '8:22',
        'image': 'https://randomuser.me/api/portraits/women/12.jpg'
      },
      {
        'name': 'Mike',
        'last': 'Nice to meet you...',
        'time': '8:47',
        'image': 'https://randomuser.me/api/portraits/men/33.jpg'
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Chat",
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final c = chats[index];
                  return ChatTile(
                    name: c['name']!,
                    lastMessage: c['last']!,
                    time: c['time']!,
                    imageUrl: c['image']!,
                    onTap: () {
                      // TODO: Navigate to conversation page
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}