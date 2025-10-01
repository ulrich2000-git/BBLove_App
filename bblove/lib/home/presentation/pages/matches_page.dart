import 'package:bblove/home/presentation/pages/match_confirmation_page.dart';
import 'package:flutter/material.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste fictive (sera remplacée plus tard par les données API / DB)
    final List<Map<String, String>> matches = [
      {"name": "Emma", "image": "assets/images/emma.jpg"},
      {"name": "John", "image": "assets/images/john.jpg"},
      {"name": "Mia", "image": "assets/images/mia.jpg"},
      {"name": "James", "image": "assets/images/james.jpg"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F4), // fond doux
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              const Text(
                "Match",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Liste des matchs
              Expanded(
                child: ListView.separated(
                  itemCount: matches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Photo profil
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(match["image"]!),
                          ),
                          const SizedBox(width: 16),

                          // Nom
                          Expanded(
                            child: Text(
                              match["name"]!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Bouton Subscribe
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Action pour abonnement
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (_) => MatchConfirmationPage(name: match["name"]!),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Subscribe",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
