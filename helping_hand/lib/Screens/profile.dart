import 'package:flutter/material.dart';

import 'homescreen.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers for the text fields to edit user details
  final TextEditingController nameController = TextEditingController(text: 'John Doe');
  final TextEditingController mobileController = TextEditingController(text: '123-456-7890');
  final TextEditingController addressController = TextEditingController(text: '123 Main St, Springfield, IL');
  final TextEditingController cityController = TextEditingController(text: 'Springfield');
  final TextEditingController roleController = TextEditingController(text: 'Software Engineer');

  bool isEditing = false; // Flag to toggle between view and edit mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White arrow icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the home screen
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white), // Profile text in white color
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF009a16), // Green color for navbar
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // White logout icon
            onPressed: () {
              // Navigate to Login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Centered Avatar Image
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://img.icons8.com/ios/452/user.png'), // Placeholder avatar image
              ),
              const SizedBox(height: 20),

              // User Info Fields with the option to edit, wrapped in a highlighted container
              _buildUserInfoContainer('Name', nameController, isEditing),
              const SizedBox(height: 10),
              _buildUserInfoContainer('Mobile Number', mobileController, isEditing),
              const SizedBox(height: 10),
              _buildUserInfoContainer('Address', addressController, isEditing),
              const SizedBox(height: 10),
              _buildUserInfoContainer('City', cityController, isEditing),
              const SizedBox(height: 10),
              _buildUserInfoContainer('Role', roleController, isEditing),
              const SizedBox(height: 20),

              // Edit Button to toggle edit mode at the end
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing; // Toggle the edit mode
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009a16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(isEditing ? 'Save' : 'Edit', style: const TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build user info fields with edit functionality wrapped in a highlighted container
  Widget _buildUserInfoContainer(String label, TextEditingController controller, bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green[50], // Light green background for highlighting
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green), // Green border to highlight
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: isEditing
                ? TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            )
                : Text(
              controller.text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
