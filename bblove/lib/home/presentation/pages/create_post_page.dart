import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  final Function(String text, String? imageBase64)? onPostCreated;

  const CreatePostPage({super.key, this.onPostCreated});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  String? _imageBase64;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // 📸 Sélection d’image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    setState(() {
      _selectedImage = file;
      _imageBase64 = base64Encode(bytes);
    });
  }

  // 🚀 Publication du post
  Future<void> _publishPost() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Écris quelque chose ou ajoute une image")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tu dois être connecté pour publier.")),
        );
        return;
      }

      await _firestore.collection('posts').add({
        'userId': user.uid,
        'userName': user.displayName ?? 'Utilisateur',
        'userAvatar': user.photoURL ??
            "https://randomuser.me/api/portraits/men/99.jpg",
        'content': text,
        'imageBase64': _imageBase64,
        'likes': 0,
        'comments': 0,
        'isLiked': false,
        'timestamp': FieldValue.serverTimestamp(),
      });

      widget.onPostCreated?.call(text, _imageBase64);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Publication envoyée ✅")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Créer une publication",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.4,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isLoading ? null : _publishPost,
              style: TextButton.styleFrom(
                foregroundColor: Colors.pinkAccent,
              ),
              child: const Text(
                "Publier",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👤 En-tête : avatar + nom + "public"
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    user?.photoURL ??
                        "https://randomuser.me/api/portraits/men/99.jpg",
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "Utilisateur",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.public, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "Public",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 💬 Champ de texte principal
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "À quoi pensez-vous ?",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),

            // 🖼️ Image choisie
            if (_selectedImage != null) ...[
              const SizedBox(height: 10),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close,
                            color: Colors.white, size: 20),
                        onPressed: () => setState(() {
                          _selectedImage = null;
                          _imageBase64 = null;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // 📍 Barre d’options d’ajout (comme Facebook)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionIcon(Icons.image, "Photo", Colors.green, _pickImage),
                  _buildActionIcon(Icons.tag_faces, "Humeur", Colors.orange, () {}),
                  _buildActionIcon(Icons.person_add, "Tag", Colors.blue, () {}),
                  _buildActionIcon(Icons.location_on, "Lieu", Colors.red, () {}),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (_isLoading)
              const CircularProgressIndicator(color: Colors.pinkAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}