import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String user;
  final String avatar;
  final String content;
  final Widget? imageWidget; // 👈 accepte un widget (Image.memory ou Image.network)
  final int likes;
  final int comments;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostWidget({
    super.key,
    required this.user,
    required this.avatar,
    required this.content,
    this.imageWidget,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Nom
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(avatar)),
                const SizedBox(width: 8),
                Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),

            // Texte
            Text(content),

            const SizedBox(height: 8),

            // Image (si présente)
            if (imageWidget != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget!,
              ),

            const SizedBox(height: 8),

            // Actions (Like / Comment)
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.pinkAccent : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text("$likes likes"),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.grey),
                  onPressed: onComment,
                ),
                Text("$comments comments"),
              ],
            )
          ],
        ),
      ),
    );
  }
}