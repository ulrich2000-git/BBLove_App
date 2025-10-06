import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🩷 Dégradé de fond inspiré de la maquette
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6A88), Color(0xFFFF99AC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 👤 Section photo et infos
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Preity, 24",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "En relation bénie ✨",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),

                // 🔘 Statistiques principales
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _StatItem(label: "PROGRÈS", value: "54%"),
                      _StatItem(label: "NIVEAU", value: "152"),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 🧮 Statistiques secondaires
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _InfoCard(icon: Icons.favorite, color: Colors.pinkAccent, label: "New Matches", value: "13"),
                    _InfoCard(icon: Icons.chat_bubble_outline, color: Colors.orangeAccent, label: "Messages", value: "264"),
                    _InfoCard(icon: Icons.people_outline, color: Colors.blueAccent, label: "Profile Views", value: "76"),
                    _InfoCard(icon: Icons.flash_on, color: Colors.purpleAccent, label: "Super Likes", value: "42"),
                  ],
                ),
                const SizedBox(height: 30),

                // ⚙️ Bouton paramètres
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined),
                  label: const Text(
                    "Paramètres du profil",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🔹 Widget pour les stats principales (progression, niveau)
class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

// 🔹 Widget pour chaque carte d’infos
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
