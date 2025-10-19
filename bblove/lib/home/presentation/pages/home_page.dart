import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/status_widget.dart';
import 'create_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  Future<void> _setupPushNotifications() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();
    final user = _auth.currentUser;
    if (user != null && token != null) {
      await _firestore.collection("users").doc(user.uid).update({
        "fcmToken": token,
      });
    }
  }

  Stream<QuerySnapshot> getPostsStream() {
    return _firestore
        .collection("posts")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUsersStream() {
    return _firestore.collection("users").snapshots();
  }

  Future<void> _toggleLike(String postId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final postRef = _firestore.collection("posts").doc(postId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(postRef);
      if (!snapshot.exists) return;
      final data = snapshot.data() as Map<String, dynamic>;
      final likedBy = List<String>.from(data["likedBy"] ?? []);
      if (likedBy.contains(user.uid)) {
        likedBy.remove(user.uid);
      } else {
        likedBy.add(user.uid);
      }
      transaction.update(postRef, {
        "likedBy": likedBy,
        "likes": likedBy.length,
      });
    });
  }

  void _openComments(String postId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ouverture des commentaires du post $postId...")),
    );
  }

  void _createPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostPage(
          onPostCreated: (text, imageBase64) async {
            final user = _auth.currentUser;
            if (user == null) return;
            final userDoc =
                await _firestore.collection("users").doc(user.uid).get();
            final userData = userDoc.data() ?? {};
            final userName = userData["fullName"];
            if (userName == null || userName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("⚠️ Vous devez avoir un nom pour publier.")),
              );
              return;
            }

            await _firestore.collection("posts").add({
              "userId": user.uid,
              "userName": userName,
              "userAvatar": userData["photoBase64"] ??
                  "https://randomuser.me/api/portraits/men/99.jpg",
              "content": text,
              "imageBase64": imageBase64,
              "likes": 0,
              "likedBy": [],
              "comments": 0,
              "timestamp": FieldValue.serverTimestamp(),
            });
          },
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inSeconds < 60) return "il y a ${diff.inSeconds}s";
    if (diff.inMinutes < 60) return "il y a ${diff.inMinutes} min";
    if (diff.inHours < 24) return "il y a ${diff.inHours} h";
    return DateFormat('dd MMM à HH:mm', 'fr_FR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),

      /// 🔹 Nouvelle AppBar façon Facebook
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 32),
            const SizedBox(width: 10),
            const Text(
              "BBLove",
              style: TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("🔔 Aucune notification pour l’instant")),
              );
            },
          ),
        ],
      ),

      /// 🌸 Contenu principal
      body: Column(
        children: [
          /// 🧡 Statuts horizontaux
          SizedBox(
            height: 90,
            child: StreamBuilder<QuerySnapshot>(
              stream: getUsersStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;
                final currentUserId = currentUser?.uid;

                final sortedUsers = users.toList()
                  ..sort((a, b) {
                    if (a.id == currentUserId) return -1;
                    if (b.id == currentUserId) return 1;
                    return 0;
                  });

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sortedUsers.length,
                  itemBuilder: (context, index) {
                    final userData =
                        sortedUsers[index].data() as Map<String, dynamic>;
                    final isCurrentUser = sortedUsers[index].id == currentUserId;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          StatusWidget(
                            name: userData["fullName"] ?? "User",
                            avatar: userData["photoBase64"] ??
                                "https://randomuser.me/api/portraits/men/1.jpg",
                            isAddButton: isCurrentUser,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData["fullName"]?.split(' ').first ?? "User",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const Divider(height: 1),

          /// 💖 Liste des posts
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getPostsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!.docs;

                // 🔹 Supprime les posts où userName == "Utilisateur"
                final filteredPosts = posts.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = data["userName"] ?? "";
                  return name.toString().trim().toLowerCase() != "utilisateur";
                }).toList();

                if (filteredPosts.isEmpty) {
                  return const Center(
                    child: Text("Aucune publication disponible."),
                  );
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  physics: const BouncingScrollPhysics(),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    final data =
                        filteredPosts[index].data() as Map<String, dynamic>;
                    final postId = filteredPosts[index].id;

                    Widget? imageWidget;
                    final imageBase64 = data["imageBase64"];
                    if (imageBase64 != null && imageBase64.isNotEmpty) {
                      try {
                        imageWidget = ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(imageBase64),
                            fit: BoxFit.cover,
                            height: 220,
                            width: double.infinity,
                          ),
                        );
                      } catch (_) {}
                    }

                    final likedBy = List<String>.from(data["likedBy"] ?? []);
                    final isLiked = likedBy.contains(currentUser?.uid);

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🔹 Header utilisateur
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                    data["userAvatar"] ??
                                        "https://randomuser.me/api/portraits/men/10.jpg",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data["userName"] ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        _formatTimestamp(data["timestamp"]),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz,
                                      color: Colors.grey),
                                  onPressed: () {},
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            if (data["content"] != null &&
                                data["content"].toString().isNotEmpty)
                              Text(
                                data["content"],
                                style: const TextStyle(fontSize: 15),
                              ),
                            const SizedBox(height: 8),

                            if (imageWidget != null) imageWidget,

                            const SizedBox(height: 8),
                            const Divider(),

                            /// ❤️ Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _actionIcon(
                                  icon: Icons.favorite,
                                  color: isLiked
                                      ? Colors.pinkAccent
                                      : Colors.grey.shade600,
                                  count: data["likes"] ?? 0,
                                  onTap: () => _toggleLike(postId),
                                ),
                                _actionIcon(
                                  icon: Icons.comment_outlined,
                                  color: Colors.grey.shade600,
                                  count: data["comments"] ?? 0,
                                  onTap: () => _openComments(postId),
                                ),
                                _actionIcon(
                                  icon: Icons.share_outlined,
                                  color: Colors.grey.shade600,
                                  count: 0,
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Fonctionnalité bientôt disponible")),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: _createPost,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Column(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(height: 2),
          Text(
            "$count",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}