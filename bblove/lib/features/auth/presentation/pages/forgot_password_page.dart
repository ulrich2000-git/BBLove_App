import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer votre email")),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Un lien de réinitialisation a été envoyé à $email")),
      );

      Navigator.pushReplacementNamed(context, "/login");
    } on FirebaseAuthException catch (e) {
      String message = "Une erreur est survenue";

      if (e.code == 'user-not-found') {
        message = "Aucun utilisateur trouvé avec cet email";
      } else if (e.code == 'invalid-email') {
        message = "Adresse email invalide";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "Entrez votre email pour recevoir un lien de réinitialisation.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),

              PrimaryButton(
                text: "Envoyer le lien",
                onPressed: _resetPassword,
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/login"),
                child: const Text("Retour à la connexion"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
