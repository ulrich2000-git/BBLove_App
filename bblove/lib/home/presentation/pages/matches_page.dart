import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final CardSwiperController controller = CardSwiperController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔥 Liste des profils à afficher
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /// 🧩 Récupérer les utilisateurs Firestore
  Future<void> _fetchUsers() async {
    final currentUser = _auth.currentUser;
    try {
      final snapshot = await _firestore.collection("users").get();

      final List<Map<String, dynamic>> fetchedUsers = [];

      for (var doc in snapshot.docs) {
        // Ignorer l’utilisateur connecté
        if (doc.id == currentUser?.uid) continue;

        final data = doc.data();
        if (data["fullName"] == null) continue;

        // Récupérer image (Base64 ou URL)
        String? imageUrl;
        if (data["photoBase64"] != null && data["photoBase64"].toString().isNotEmpty) {
          imageUrl = data["photoBase64"];
        } else if (data["photoUrl"] != null) {
          imageUrl = data["photoUrl"];
        } else {
          imageUrl = "https://randomuser.me/api/portraits/women/${fetchedUsers.length + 1}.jpg";
        }

        fetchedUsers.add({
          "id": doc.id,
          "name": data["fullName"],
          "age": data["age"] ?? 0,
          "distance": data["distance"] ?? "inconnue",
          "image": imageUrl,
        });
      }

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur Firestore : $e");
      setState(() => isLoading = false);
    }
  }

  /// ❤️ Action "Like"
  void _likeUser(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore.collection("likes").add({
        "fromUser": currentUser.uid,
        "toUser": userId,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erreur lors du like : $e");
    }
  }

  /// ❌ Action "Dislike"
  void _dislikeUser(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore.collection("dislikes").add({
        "fromUser": currentUser.uid,
        "toUser": userId,
        "timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erreur lors du dislike : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : users.isEmpty
                ? const Center(
                    child: Text(
                      "Aucun profil à afficher 😕",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Matching 💞",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🃏 Swiper des profils Firestore
                      Expanded(
                        child: CardSwiper(
                          controller: controller,
                          cardsCount: users.length,
                          numberOfCardsDisplayed: 1,
                          onSwipe: (previousIndex, currentIndex, direction) {
                            final swipedUser = users[previousIndex];
                            if (direction == CardSwiperDirection.right) {
                              _likeUser(swipedUser["id"]);
                            } else if (direction == CardSwiperDirection.left) {
                              _dislikeUser(swipedUser["id"]);
                            }
                            return true;
                          },
                          cardBuilder: (context, index, h, v) {
                            final user = users[index];
                            return _buildProfileCard(user);
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ❤️ Boutons Like / Dislike
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _actionButton(Icons.close, Colors.grey.shade400, () {
                            controller.swipe(CardSwiperDirection.left);
                          }),
                          _actionButton(Icons.favorite, Colors.pinkAccent, () {
                            controller.swipe(CardSwiperDirection.right);
                          }),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
      ),
    );
  }

  /// 🧱 Carte profil utilisateur
  Widget _buildProfileCard(Map<String, dynamic> user) {
    Widget imageWidget;
    final image = user["image"];

    // Vérifie si c’est du base64 ou une URL
    if (image != null && image.toString().startsWith("/9j")) {
      try {
        imageWidget = Image.memory(
          base64Decode(image),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      } catch (_) {
        imageWidget = Image.network(
          "https://randomuser.me/api/portraits/women/5.jpg",
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    } else {
      imageWidget = Image.network(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned.fill(child: imageWidget),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            child: Text(
              "${user["name"]}, ${user["age"]} ans\n${user["distance"]} away",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 Bouton Like/Dislike
  Widget _actionButton(IconData icon, Color color, VoidCallback onPressed) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: color,
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}