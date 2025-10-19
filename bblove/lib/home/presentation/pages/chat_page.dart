import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/chat_tile.dart';
import 'conversation_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final usersRef = FirebaseFirestore.instance.collection('users');
    final convRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('conversations')
        .orderBy('timestamp', descending: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        title: const Text(
          "Discussions",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Barre de recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher...",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // 🟢 Section "En ligne"
          SizedBox(
            height: 95,
            child: StreamBuilder<QuerySnapshot>(
              stream: usersRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Aucun utilisateur en ligne"));
                }

                final users = snapshot.data!.docs.take(10).toList();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final imageUrl = user['photoUrl'] ??
                        'https://cdn-icons-png.flaticon.com/512/1077/1077012.png';
                    final name = user['fullName'] ?? 'User';

                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundImage: NetworkImage(imageUrl),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  height: 12,
                                  width: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            name.split(' ').first,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 💬 Liste des conversations récentes
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: convRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "Aucune discussion pour l’instant 💬",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final conversations = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conv = conversations[index].data() as Map<String, dynamic>;
                    final receiverName = conv['name'] ?? 'Utilisateur';
                    final receiverImage = conv['image'] ??
                        'https://cdn-icons-png.flaticon.com/512/1077/1077012.png';
                    final lastMessage = conv['lastMessage'] ?? '';
                    final timestamp = conv['timestamp'] as Timestamp?;
                    final time = timestamp != null
                        ? _formatTime(timestamp.toDate())
                        : '';

                    return ChatTile(
                      name: receiverName,
                      lastMessage: lastMessage,
                      time: time,
                      imageUrl: receiverImage,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConversationPage(
                              receiverId: conversations[index].id,
                              receiverName: receiverName,
                              receiverImage: receiverImage, name: null,
                            ),
                          ),
                        );
                      },
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

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return "Maintenant";
    if (difference.inHours < 1) return "${difference.inMinutes} min";
    if (difference.inHours < 24) return "${difference.inHours} h";
    return "${dateTime.day}/${dateTime.month}";
  }
}