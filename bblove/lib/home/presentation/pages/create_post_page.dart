import 'dart:io';
import 'dart:convert'; // pour base64
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  // onPostCreated reçoit maintenant un texte + imageBase64 (string) plutôt que File
  final Function(String text, String? imageBase64) onPostCreated;

  const CreatePostPage({super.key, required this.onPostCreated});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  String? _imageBase64;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Convertir en Base64
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      setState(() {
        _selectedImage = file;
        _imageBase64 = base64Image;
      });
    }
  }

  void _publishPost() {
    final text = _textController.text.trim();
    if (text.isEmpty && _imageBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Write something or add an image")),
      );
      return;
    }

    // Retourner texte + image en Base64
    widget.onPostCreated(text, _imageBase64);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        actions: [
          TextButton(
            onPressed: _publishPost,
            child: const Text(
              "Publish",
              style: TextStyle(color: Colors.pinkAccent, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champ texte
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Image preview
            if (_selectedImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, height: 200, fit: BoxFit.cover),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 18),
                        onPressed: () {
                          setState(() {
                            _selectedImage = null;
                            _imageBase64 = null;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),

            const SizedBox(height: 16),

            // Bouton ajouter image
            OutlinedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image, color: Colors.pinkAccent),
              label: const Text("Add Image"),
            ),
          ],
        ),
      ),
    );
  }
}
