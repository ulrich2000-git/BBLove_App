import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// 🔹 Thème et pages d'authentification
import 'core/theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';

// 🔹 Pages principales
import 'package:bblove/home/presentation/pages/home_page.dart';
import 'package:bblove/home/presentation/pages/chat_page.dart';
import 'package:bblove/home/presentation/pages/matches_page.dart';
import 'package:bblove/home/presentation/pages/profile_page.dart';

// 🔹 Packages externes
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// 🔹 Fichier généré automatiquement par `flutterfire configure`
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        "/forgot-password": (_) => const ForgotPasswordPage(),
        "/home": (_) => const MainNavigation(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    const MatchPage(),
    ProfilePage(userId: FirebaseAuth.instance.currentUser?.uid ?? ''),
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
              ),
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Accueil"),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.chat_bubble_outline),
                title: const Text("Message"),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.people_outline),
                title: const Text("Matching"),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                title: const Text("Profil"),
                selectedColor: Colors.pinkAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> ensureUserDocument() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final snapshot = await doc.get();
  if (!snapshot.exists) {
    await doc.set({
      'uid': user.uid,
      'fullName': user.displayName ?? 'Utilisateur',
      'email': user.email ?? '',
      'photoBase64': '',
      'bio': '',
      'age': 'N/A',
      'gender': '',
      'location': '',
      'interests': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
} 