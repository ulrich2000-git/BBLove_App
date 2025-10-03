import 'package:flutter/material.dart';
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
      "image": "https://picsum.photos/400/300",
      "likes": 23,
      "comments": 5,
      "isLiked": false,
    },
    {
      "user": "John",
      "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
      "content": "Just had an amazing coffee ☕️",
      "image": null,
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Open create post page")),
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
                return PostWidget(
                  user: post["user"],
                  avatar: post["avatar"],
                  content: post["content"],
                  image: post["image"],
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

      // Floating Button pour publier
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: _createPost,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
