import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F4), // Couleur douce de fond
      body: SafeArea(
        child: Column(
          children: [
            // Barre de navigation simple
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // pour équilibrer la flèche gauche
                ],
              ),
            ),

            // Image de couverture + photo de profil
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/cover.jpg"), // 🔑 image de couverture
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/images/profile.jpg"), // 🔑 photo profil
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Infos utilisateur
            const Text(
              "Emma",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "26",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              "Coffee lover and nature enthusiast",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Centres d’intérêt
            Wrap(
              spacing: 10,
              children: const [
                Chip(
                  label: Text("Travel"),
                  backgroundColor: Color(0xFFF1EFEF),
                ),
                Chip(
                  label: Text("Art"),
                  backgroundColor: Color(0xFFF1EFEF),
                ),
                Chip(
                  label: Text("Cooking"),
                  backgroundColor: Color(0xFFF1EFEF),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Boutons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.transparent),
                        backgroundColor: Color(0xFFF1EFEF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
