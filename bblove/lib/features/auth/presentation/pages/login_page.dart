import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // Logo + Nom
              Column(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    "BBLove",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Champs Email + Password
              const CustomTextField(
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: "Password",
                obscureText: true,
              ),

              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, "/forgot-password"),
                  child: const Text("Forgot password?"),
                ),
              ),

              const SizedBox(height: 16),

              // Login Button
              PrimaryButton(
                text: "Log In",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
              ),

              const SizedBox(height: 16),

              // SignUp Button
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, "/signup"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 24),

              // Bottom link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/signup"),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}