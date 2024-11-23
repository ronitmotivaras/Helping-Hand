import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Fetch notifications from Firestore
  Future<List<DocumentSnapshot>> fetchNotifications() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Notifications') // Collection name (adjust as needed)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      print("Error fetching notifications: $e"); // Debugging error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Color(0xFF009a16),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No notifications available"));
          }

          // Extract notifications from snapshot
          List<DocumentSnapshot> notifications = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                var notification = notifications[index].data() as Map<String, dynamic>;
                String organizationOrNeedy = notification['organizationOrNeedy'] ?? "Unknown";
                String imageUrl = notification['imageUrl'] ?? "https://example.com/default_image.jpg"; // Replace with your default image URL
                String requestDate = notification['requestDate'] ?? "Not available";

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(
                      organizationOrNeedy,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text('Requested on: $requestDate'),
                    trailing: Icon(Icons.notification_important, color: Color(0xFF009a16)),
                    onTap: () {
                      // You can add functionality here when a notification is tapped
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
