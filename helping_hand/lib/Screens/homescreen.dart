import 'package:flutter/material.dart';
import 'package:helping_hand/Screens/profile.dart';
import 'donate.dart';
import 'login.dart';
import 'notification.dart';
import 'request.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Helping Hand',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFF009a16), // Green color for navbar
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white), // Profile icon in white
          onPressed: () {
            // Navigate to Profile screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white), // Notification icon in white
            onPressed: () {
              // Navigate to Notification screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), // Logout icon in white
            onPressed: () {
              // Handle logout logic, navigate to Login screen
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
        child: ListView(
          children: [
            // User 1
            ListTile(
              leading: Image.network(
                'https://img.icons8.com/ios/452/user.png', // User icon from Flaticon
                width: 40,
                height: 40,
              ),
              title: Center(
                child: const Text(
                  'John Doe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              subtitle: Center(
                child: const Text(
                  'New York', // Only city name
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Divider(),

            // User 2
            ListTile(
              leading: Image.network(
                'https://img.icons8.com/ios/452/user.png', // User icon from Flaticon
                width: 40,
                height: 40,
              ),
              title: Center(
                child: const Text(
                  'Jane Smith',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              subtitle: Center(
                child: const Text(
                  'Los Angeles', // Only city name
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Divider(),

            // User 3
            ListTile(
              leading: Image.network(
                'https://img.icons8.com/ios/452/user.png', // User icon from Flaticon
                width: 40,
                height: 40,
              ),
              title: Center(
                child: const Text(
                  'Alice Johnson',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              subtitle: Center(
                child: const Text(
                  'San Francisco', // Only city name
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Divider(),

            // Add more users here in the same way
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to DonateFoodScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DonateFoodScreen()), // Navigate to DonateFoodScreen
          );
        },
        backgroundColor: const Color(0xFF009a16), // Same green color for button
        icon: const Icon(Icons.add, color: Colors.white), // Plus icon for donate button, white color
        label: const Text(
          'Donate',
          style: TextStyle(color: Colors.white),
        ), // Added "Donate" text
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ensures the button is at the bottom-right
    );
  }
}
