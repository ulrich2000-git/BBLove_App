import 'package:bblove/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:bblove/features/auth/presentation/widgets/primary_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
                "Entrez votre email pour réinitialiser votre mot de passe.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const CustomTextField(
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: "Réinitialiser",
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Lien envoyé à votre email")),
                  );
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, "/login"),
                child: const Text("Retour à la connexion"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}