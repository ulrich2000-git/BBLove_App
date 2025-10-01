import 'package:flutter/material.dart';

class SwipeCard extends StatelessWidget {
  final String name;
  final int age;
  final String bio;
  final String imageUrl;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onSuperLike;

  const SwipeCard({
    super.key,
    required this.name,
    required this.bio,
    required this.imageUrl, required this.age,
    this.onLike,
    this.onDislike,
    this.onSuperLike,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.hardEdge,
      elevation: 6,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(bio, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}