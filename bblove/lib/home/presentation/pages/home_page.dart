import 'package:flutter/material.dart';
import '../widgets/swipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Example data queue
  final List<Map<String, dynamic>> _profiles = [
    {
      'name': 'Olivia',
      'age': 26,
      'bio': 'I love trying new recipes and traveling.',
      'image': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800&q=80'
    },
    {
      'name': 'John',
      'age': 28,
      'bio': 'Coffee lover ☕, runner and photographer.',
      'image': 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800&q=80'
    },
    // add more sample profiles if needed
  ];

  int _currentIndex = 0;
  bool _showActionOverlay = false;
  String? _lastAction; // "liked","disliked","superlike"

  void _advanceProfile() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _profiles.length;
    });
  }

  void _onLike() {
    setState(() {
      _lastAction = "liked";
      _showActionOverlay = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => _showActionOverlay = false);
      _advanceProfile();
    });
  }

  void _onDislike() {
    setState(() {
      _lastAction = "disliked";
      _showActionOverlay = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => _showActionOverlay = false);
      _advanceProfile();
    });
  }

  void _onSuperLike() {
    setState(() {
      _lastAction = "superlike";
      _showActionOverlay = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => _showActionOverlay = false);
      _advanceProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profiles[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            // Top small indicator like notch area in mockups
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card stack area
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // optionally show behind card(s) for depth
                  Positioned(
                    top: 24,
                    child: Opacity(
                      opacity: 0.6,
                      child: Transform.scale(
                        scale: 0.95,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.86,
                          height: (MediaQuery.of(context).size.width * 0.86) * 1.25,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Main swipe card
                  SwipeCard(
                    name: profile['name'],
                    age: profile['age'],
                    bio: profile['bio'],
                    imageUrl: profile['image'],
                    onLike: _onLike,
                    onDislike: _onDislike,
                    onSuperLike: _onSuperLike,
                  ),

                  // Floating overlay to show last action (tiny feedback)
                  if (_showActionOverlay && _lastAction != null)
                    Positioned(
                      top: 24,
                      right: 28,
                      child: AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 200),
                        child: _buildActionBadge(_lastAction!),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bottom action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    icon: Icons.close,
                    background: Colors.white,
                    foreground: Colors.red.shade400,
                    onTap: () => _onDislike(),
                    size: 62,
                  ),
                  _actionButton(
                    icon: Icons.favorite,
                    background: Colors.pink,
                    foreground: Colors.white,
                    onTap: () => _onLike(),
                    size: 76,
                    elevation: 8,
                  ),
                  _actionButton(
                    icon: Icons.star,
                    background: Colors.white,
                    foreground: Colors.grey.shade800,
                    onTap: () => _onSuperLike(),
                    size: 62,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
    double size = 60,
    double elevation = 2,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            boxShadow: elevation > 0
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: elevation,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Icon(icon, color: foreground, size: size * 0.45),
        ),
      ),
    );
  }

  Widget _buildActionBadge(String action) {
    switch (action) {
      case "liked":
        return _badge(Icons.favorite, Colors.pink, "Liked");
      case "disliked":
        return _badge(Icons.close, Colors.red, "Skipped");
      case "superlike":
        return _badge(Icons.star, Colors.blue, "Super");
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _badge(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0,4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}