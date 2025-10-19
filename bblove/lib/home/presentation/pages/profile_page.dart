import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String? userId;
  const ProfilePage({super.key, this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final String uid;
  bool _isLoading = true;
  bool _isDark = false;
  Map<String, dynamic>? _userData;
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    uid = widget.userId ?? (_auth.currentUser?.uid ?? '');
    _initProfile();
  }

  Future<void> _initProfile() async {
    if (uid.isEmpty) {
      setState(() {
        _isLoading = false;
        _userData = {
          'fullName': 'Utilisateur',
          'bio': 'Aucun utilisateur trouvé',
        };
      });
      return;
    }

    try {
      final docRef = _firestore.collection('users').doc(uid);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        final currentUser = _auth.currentUser;
        await docRef.set({
          'uid': uid,
          'fullName': currentUser?.displayName ?? 'Utilisateur',
          'email': currentUser?.email ?? '',
          'bio': '',
          'photoBase64': '',
          'photoURL': currentUser?.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final fresh = await docRef.get();
      setState(() {
        _userData = fresh.data();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur init profile: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    setState(() => _pickedImageFile = File(picked.path));
    final bytes = await _pickedImageFile!.readAsBytes();
    final base64Image = base64Encode(bytes);

    try {
      await _firestore.collection('users').doc(uid).update({
        'photoBase64': base64Image,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await _initProfile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo mise à jour ✅')),
        );
      }
    } catch (e) {
      debugPrint('Erreur update image: $e');
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  // 🔗 Ouvre une URL externe
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d’ouvrir $url')),
      );
    }
  }

  Widget _buildHeader() {
    final data = _userData ?? {};
    final name = data['fullName'] ?? 'Utilisateur';
    final bio = data['bio'] ?? '';

    ImageProvider avatar;
    if (data['photoBase64'] != null && (data['photoBase64'] as String).isNotEmpty) {
      try {
        avatar = MemoryImage(base64Decode(data['photoBase64'] as String));
      } catch (_) {
        avatar = const AssetImage('assets/logo.png');
      }
    } else {
      avatar = const NetworkImage('https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg');
    }

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(radius: 55, backgroundImage: avatar),
            if (_auth.currentUser?.uid == uid)
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.pinkAccent),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _isDark ? Colors.white : Colors.pinkAccent,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          bio.isEmpty ? 'Bio non renseignée' : bio,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _isDark ? Colors.white70 : Colors.black87,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _openUrl(url),
      child: Card(
        elevation: 5,
        color: _isDark ? Colors.grey[900] : Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: _isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgGradient = _isDark
        ? const LinearGradient(colors: [Colors.black87, Colors.black])
        : const LinearGradient(colors: [Color(0xFFFFF0F3), Color(0xFFFFEAF0)]);

    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: _isDark ? Colors.black : Colors.pinkAccent,
        actions: [
          IconButton(
            icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => _isDark = !_isDark),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // 🌸 Cartes de navigation
                      _buildActionCard(
                        title: "Demande de Coaching",
                        icon: Icons.favorite_border,
                        color: Colors.pinkAccent,
                        url: "https://bb-love.com/coaching",
                      ),
                      _buildActionCard(
                        title: "Événements à venir",
                        icon: Icons.event,
                        color: Colors.orangeAccent,
                        url: "https://bb-love.com/evenements",
                      ),
                      _buildActionCard(
                        title: "Surprise du jour 🎁",
                        icon: Icons.card_giftcard,
                        color: Colors.purpleAccent,
                        url: "https://bb-love.com/surprise",
                      ),

                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _logout,
                        icon: const Icon(Icons.logout),
                        label: const Text("Se déconnecter"),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}