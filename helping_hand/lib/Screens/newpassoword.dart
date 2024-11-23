import 'package:flutter/material.dart';

import 'login.dart';

void main() {
  runApp(const MaterialApp(
    home: NewPasswordScreen(),
  ));
}

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // For toggling password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Function to validate new password
  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your new password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // Check if the password contains only letters, numbers, or @ symbol
    RegExp regex = RegExp(r'^[A-Za-z0-9@]+$');
    if (!regex.hasMatch(value)) {
      return 'Password can only contain letters, numbers, and @ symbol';
    }
    return null;
  }

  // Function to validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Function to update password (for now it just prints a success message)
  void _updatePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Logic to update the password would go here, such as an API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      // Navigate back to the login screen after successful password update
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        ),
        title: const Text('New Password'),
        backgroundColor: const Color(0xFF009a16), // Green color for navbar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title for New Password screen
              const Text(
                'Enter New Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF009a16), // Green color for text
                ),
              ),
              const SizedBox(height: 20),

              // New Password input field
              TextFormField(
                controller: newPasswordController,
                obscureText: !_isPasswordVisible,  // Password visibility toggle
                decoration: InputDecoration(
                  labelText: 'Enter New Password',
                  hintText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: _validateNewPassword, // Validate new password
              ),
              const SizedBox(height: 20),

              // Confirm Password input field
              TextFormField(
                controller: confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,  // Password visibility toggle
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: _validateConfirmPassword, // Validate confirm password
              ),
              const SizedBox(height: 20),

              // Update Password button
              ElevatedButton(
                onPressed: _updatePassword, // Call update password function
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009a16), // Green color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Update Password',
                  style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
