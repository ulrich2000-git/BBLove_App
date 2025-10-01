import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/signup_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';

// Pages principales
import 'package:bblove/home/presentation/pages/home_page.dart';
import 'package:bblove/home/presentation/pages/chat_page.dart';
import 'package:bblove/home/presentation/pages/matches_page.dart';
import 'package:bblove/home/presentation/pages/profile_page.dart';

// Package pub.dev
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() {
  runApp(const BBLoveApp());
}

class BBLoveApp extends StatelessWidget {
  const BBLoveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BBLove",
      theme: appTheme,
      initialRoute: "/splash",
      routes: {
        "/splash": (_) => const SplashPage(),
        "/login": (_) => const LoginPage(),
        "/signup": (_) => const SignUpPage(),
        "/forgot-password": (_) => const ForgotPasswordPage(),
        "/home": (_) => const MainNavigation(), // ⬅️ Navigation avec navbar
      },
    );
  }
}

/// ✅ Widget qui gère la navigation principale avec SalomonBottomBar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ChatPage(),
    MatchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.chat_bubble_outline),
                title: const Text("Chat"),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite_border),
                title: const Text("Matches"),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                title: const Text("Profile"),
                selectedColor: Colors.pinkAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}