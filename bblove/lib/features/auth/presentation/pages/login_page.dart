import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGender;
  String? _base64Photo;

  final picker = ImagePicker();

  // 📸 Choisir une image
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() => _base64Photo = base64Encode(bytes));
    }
  }

  // 🚀 Soumission (Connexion / Inscription)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    try {
      final auth = FirebaseAuth.instance;
      UserCredential userCredential;

      if (isLogin) {
        // 🔹 Connexion
        userCredential = await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 🔹 Vérifie que l’utilisateur a bien un document Firestore
        await _ensureUserDocumentExists(userCredential.user!);
      } else {
        // 🔹 Vérifications préalables
        if (_selectedGender == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Veuillez sélectionner votre sexe")),
          );
          setState(() => isLoading = false);
          return;
        }

        if (_base64Photo == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Veuillez ajouter une photo de profil")),
          );
          setState(() => isLoading = false);
          return;
        }

        // 🔹 Création du compte Firebase
        userCredential = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // 🔹 Création du document Firestore complet
        await _createUserDocument(userCredential.user!);
      }

      // ✅ Redirection vers Home
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      String message = 'Une erreur est survenue.';
      if (e.code == 'user-not-found') message = 'Utilisateur non trouvé.';
      if (e.code == 'wrong-password') message = 'Mot de passe incorrect.';
      if (e.code == 'email-already-in-use') message = 'Cet e-mail est déjà utilisé.';
      if (e.code == 'weak-password') message = 'Mot de passe trop faible.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 🔥 Fonction pour créer un document complet lors de l’inscription
  Future<void> _createUserDocument(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await usersRef.set({
      'uid': user.uid,
      'fullName': _fullNameController.text.trim(),
      'email': _emailController.text.trim(),
      'age': _ageController.text.trim(),
      'gender': _selectedGender,
      'photoBase64': _base64Photo,
      'bio': '',
      'location': '',
      'interests': [],
      'isVerified': false,
      'matchCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    debugPrint("✅ Document utilisateur créé pour ${user.uid}");
  }

  // 🧩 Si l’utilisateur se connecte et n’a pas encore de document
  Future<void> _ensureUserDocumentExists(User user) async {
    final usersRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await usersRef.get();

    if (!doc.exists) {
      await usersRef.set({
        'uid': user.uid,
        'fullName': user.displayName ?? 'Utilisateur',
        'email': user.email ?? '',
        'age': 'N/A',
        'gender': '',
        'photoBase64': '',
        'bio': '',
        'location': '',
        'interests': [],
        'isVerified': false,
        'matchCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("ℹ️ Document utilisateur créé automatiquement pour ${user.uid}");
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6A88), Color(0xFFFF99AC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Text(
                    isLogin ? "Connexion à BBLove 💕" : "Inscription à BBLove 💕",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isLogin
                        ? "Heureux de vous revoir !"
                        : "Créez un compte pour découvrir votre match parfait 💞",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => isLogin = true),
                                child: Text(
                                  "Connexion",
                                  style: TextStyle(
                                    color: isLogin
                                        ? Colors.pink.shade600
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () => setState(() => isLogin = false),
                                child: Text(
                                  "Inscription",
                                  style: TextStyle(
                                    color: !isLogin
                                        ? Colors.pink.shade600
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          if (!isLogin) ...[
                            GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.pink.shade100,
                                backgroundImage: _base64Photo != null
                                    ? MemoryImage(base64Decode(_base64Photo!))
                                    : null,
                                child: _base64Photo == null
                                    ? const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 30)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _fullNameController,
                              decoration: _inputDecoration("Nom complet", Icons.person_outline),
                              validator: (v) => v!.isEmpty
                                  ? "Veuillez entrer votre nom complet"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ],

                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration("Adresse e-mail", Icons.email_outlined),
                            validator: (v) =>
                                v!.isEmpty ? "Veuillez entrer votre e-mail" : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: _inputDecoration("Mot de passe", Icons.lock_outline),
                            validator: (v) =>
                                v!.length < 6 ? "Mot de passe trop court" : null,
                          ),
                          const SizedBox(height: 16),

                          if (!isLogin) ...[
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: _inputDecoration("Confirmer le mot de passe", Icons.lock_reset),
                              validator: (v) {
                                if (v != _passwordController.text) {
                                  return "Les mots de passe ne correspondent pas";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration("Âge ou date de naissance", Icons.cake_outlined),
                              validator: (v) =>
                                  v!.isEmpty ? "Veuillez entrer votre âge" : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: _inputDecoration("Sexe", Icons.wc),
                              initialValue: _selectedGender,
                              items: const [
                                DropdownMenuItem(value: "Homme", child: Text("Homme")),
                                DropdownMenuItem(value: "Femme", child: Text("Femme")),
                              ],
                              onChanged: (v) => setState(() => _selectedGender = v),
                              validator: (v) =>
                                  v == null ? "Veuillez sélectionner votre sexe" : null,
                            ),
                          ],

                          const SizedBox(height: 24),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade400,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            onPressed: isLoading ? null : _submit,
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    isLogin ? "Se connecter" : "S’inscrire",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}