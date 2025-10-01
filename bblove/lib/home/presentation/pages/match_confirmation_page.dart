import 'package:bblove/home/presentation/pages/conversation_page.dart';
import 'package:flutter/material.dart';

class MatchConfirmationPage extends StatelessWidget {
  final String name; // ex: "Emma"

  const MatchConfirmationPage({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F4),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cœur rose
                const Icon(
                  Icons.favorite,
                  color: Colors.pinkAccent,
                  size: 120,
                ),
                const SizedBox(height: 32),

                // Titre
                const Text(
                  "It’s a Match!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Sous-texte dynamique
                Text(
                  "You and $name have liked each other",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Bouton Send a message
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ConversationPage(name: "Emma"),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.pinkAccent,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
  child: const Text(
    "SEND A MESSAGE",
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
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