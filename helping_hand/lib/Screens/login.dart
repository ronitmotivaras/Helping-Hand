import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'forget_password.dart';
import 'homescreen.dart';
import 'registration.dart'; // Import the Registration screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? mobileError;
  String? passwordError;

  bool isLoading = false;

  // Login function
  void login() async {
    setState(() {
      mobileError = null;
      passwordError = null;
      isLoading = true;
    });

    String mobile = mobileController.text.trim();
    String password = passwordController.text.trim();

    bool isValid = true;

    // Validate mobile number (only 10 digits allowed)
    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      mobileError = "Enter a valid 10-digit mobile number";
      isValid = false;
    }

    // Validate password (check if empty and if it meets length criteria)
    if (password.isEmpty) {
      passwordError = "Password cannot be empty";
      isValid = false;
    } else if (password.length < 6) {
      passwordError = "Password must be at least 6 characters long";
      isValid = false;
    }

    if (!isValid) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Query Firestore to find the user
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("Mobile", isEqualTo: mobile)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No user found with this mobile number.")),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Get the user data
      final user = querySnapshot.docs.first.data();

      // Check if the password matches
      if (user["Password"] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Successful!")),
        );

        // Navigate to the Home Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Incorrect password. Please try again.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during login: $error")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF009a16),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Welcome Back!",
                style: TextStyle(
                  color: const Color(0xFF009a16),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Mobile Number Field
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Mobile Number",
                  suffixIcon: const Icon(Icons.phone, color: Color(0xFF009a16)),
                  errorText: mobileError,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF009a16)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: const Icon(Icons.lock, color: Color(0xFF009a16)),
                  errorText: passwordError,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF009a16)),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Sign In Button
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009a16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      minimumSize: const Size(150, 50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Sign In",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Forgot Password and Register Yourself
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF009a16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrationForm(),
                        ),
                      );
                    },
                    child: const Text(
                      "Register Yourself",
                      style: TextStyle(
                        color: Color(0xFF009a16),
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
