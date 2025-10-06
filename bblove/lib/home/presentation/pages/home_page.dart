import 'dart:convert'; // pour base64Decode
import 'package:flutter/material.dart';
import 'create_post_page.dart';
import '../widgets/status_widget.dart';
import '../widgets/post_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _posts = [
    {
      "user": "Emma",
      "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
      "content": "Beautiful sunset today 🌅",
      "imageUrl": "https://picsum.photos/400/300", // 👈 image réseau
      "imageBase64": null, // 👈 aucune image en base64
      "likes": 23,
      "comments": 5,
      "isLiked": false,
    },
    {
      "user": "John",
      "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
      "content": "Just had an amazing coffee ☕️",
      "imageUrl": null,
      "imageBase64": null,
      "likes": 10,
      "comments": 2,
      "isLiked": true,
    },
  ];

  void _toggleLike(int index) {
    setState(() {
      _posts[index]["isLiked"] = !_posts[index]["isLiked"];
      if (_posts[index]["isLiked"]) {
        _posts[index]["likes"]++;
      } else {
        _posts[index]["likes"]--;
      }
    });
  }

  void _openComments(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Open comments for ${_posts[index]['user']}")),
    );
  }

  void _createPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreatePostPage(
          onPostCreated: (text, String? imageBase64) {
            setState(() {
              _posts.insert(0, {
                "user": "You",
                "avatar": "https://randomuser.me/api/portraits/men/99.jpg",
                "content": text,
                "imageUrl": null, // pas d'URL si c'est un post utilisateur
                "imageBase64": imageBase64, // 👈 stocke en base64
                "likes": 0,
                "comments": 0,
                "isLiked": false,
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "BBLove",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Zone des statuts
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                StatusWidget(
                  name: "Your Story",
                  avatar: "https://randomuser.me/api/portraits/women/1.jpg",
                  isAddButton: true,
                ),
                StatusWidget(
                  name: "Emma",
                  avatar: "https://randomuser.me/api/portraits/women/44.jpg",
                ),
                StatusWidget(
                  name: "John",
                  avatar: "https://randomuser.me/api/portraits/men/32.jpg",
                ),
                StatusWidget(
                  name: "Mia",
                  avatar: "https://randomuser.me/api/portraits/women/65.jpg",
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Zone des publications
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];

                // 👇 Choisir quelle image afficher (URL ou Base64)
                Widget? imageWidget;
                if (post["imageBase64"] != null) {
                  imageWidget = Image.memory(
                    base64Decode(post["imageBase64"]),
                    height: 200,
                    fit: BoxFit.cover,
                  );
                } else if (post["imageUrl"] != null) {
                  imageWidget = Image.network(
                    post["imageUrl"],
                    height: 200,
                    fit: BoxFit.cover,
                  );
                }

                return PostWidget(
                  user: post["user"],
                  avatar: post["avatar"],
                  content: post["content"],
                  imageWidget: imageWidget, // 👈 on passe directement le widget
                  likes: post["likes"],
                  comments: post["comments"],
                  isLiked: post["isLiked"],
                  onLike: () => _toggleLike(index),
                  onComment: () => _openComments(index),
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
    );
  }
}
