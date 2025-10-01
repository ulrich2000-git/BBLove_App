import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  DateTime? _selectedDate;
  String? _selectedGender;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Icon(Icons.favorite, color: Colors.pink, size: 64),
              const SizedBox(height: 12),
              Text(
                "Create Account",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Form Fields
              const CustomTextField(
                hintText: "Full Name",
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                hintText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Date of Birth
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? "Date of Birth"
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    style: TextStyle(
                      color: _selectedDate == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                items: ["Male", "Female", "Other"]
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                hint: const Text("Select Gender"),
                onChanged: (val) {
                  setState(() {
                    _selectedGender = val;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Profile Picture Upload
              GestureDetector(
                onTap: () {
                  // Ici tu pourras brancher image_picker plus tard
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Upload profile picture")),
                  );
                },
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Sign Up Button
              PrimaryButton(
                text: "Sign Up",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/home");
                },
              ),

              const SizedBox(height: 24),

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, "/login"),
                    child: const Text(
                      "Log In",
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