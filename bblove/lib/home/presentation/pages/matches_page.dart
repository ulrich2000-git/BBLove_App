import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  final CardSwiperController controller = CardSwiperController();

  // 🔹 Mock de profils utilisateurs
  final List<Map<String, dynamic>> users = [
    {
      "name": "Jannie",
      "age": 25,
      "distance": "14 km",
      "image": "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
    },
    {
      "name": "Marianne",
      "age": 27,
      "distance": "10 km",
      "image": "https://images.pexels.com/photos/415829/pexels-photo-774909.jpeg",
    },
    {
      "name": "Céline",
      "age": 22,
      "distance": "6 km",
      "image": "https://images.pexels.com/photos/1858175/pexels-photo-1858175.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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

            // 🃏 Swiper des cartes
            Expanded(
              child: CardSwiper(
                controller: controller,
                cardsCount: users.length,
                numberOfCardsDisplayed: 1,
                onSwipe: (previousIndex, currentIndex, direction) {
                  debugPrint(
                      "Swiped ${direction.name} on ${users[previousIndex].name}");
                  return true;
                },
                cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
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

  Widget _buildProfileCard(Map<String, dynamic> user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(user["image"]),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.4), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Text(
          "${user["name"]}, ${user["age"]} ans\n${user["distance"]} away",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

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

extension on Map<String, dynamic> {
  get name => null;
}
