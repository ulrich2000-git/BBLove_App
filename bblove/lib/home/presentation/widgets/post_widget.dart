import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final String user;
  final String avatar;
  final String content;
  final String? image;
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
    this.image,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(avatar)),
            title: Text(
              user,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text("2h ago"),
            trailing: const Icon(Icons.more_vert),
          ),

          // Content text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(content),
          ),

          // Image if exists
          if (image != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(image!),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.pinkAccent : Colors.grey,
                  ),
                  onPressed: onLike,
                ),
                Text("$likes"),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                  onPressed: onComment,
                ),
                Text("$comments"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
