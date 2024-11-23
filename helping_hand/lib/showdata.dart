import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Show Data"),
        centerTitle: true,
        backgroundColor: const Color(0xFF009a16),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshots.hasError) {
            return Center(
              child: Text("Error: ${snapshots.error}"),
            );
          }
          if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("No data found"),
            );
          }

          final data = snapshots.data!.docs;

          return ListView.builder(
            itemCount: data.length, // Set the number of items
            itemBuilder: (context, index) {
              final doc = data[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text("${index + 1}"),
                ),
                title: Text(doc["Title"] ?? "No Title"), // Safely access fields
                subtitle: Text(doc["Description"] ?? "No Description"),
              );
            },
          );
        },
      ),
    );
  }
}
