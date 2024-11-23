import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonateFoodScreen extends StatefulWidget {
  @override
  _DonateFoodScreenState createState() => _DonateFoodScreenState();
}

class _DonateFoodScreenState extends State<DonateFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _foodDescriptionController = TextEditingController();
  TextEditingController _donationDateController = TextEditingController();
  File? _imageFile;

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Method to pick a date for donation
  Future<void> _pickDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        // Format the date as yyyy-MM-dd
        _donationDateController.text =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // Submit the donation details
  void _submitDonation() {
    if (_formKey.currentState!.validate() &&
        _donationDateController.text.isNotEmpty &&
        _imageFile != null) {
      // Handle the submission logic (e.g., uploading to Firestore or backend)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation Submitted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate Food'),
        backgroundColor: const Color(0xFF009a16), // Green color for navbar
        foregroundColor: Colors.white, // White text color in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Upload Image Button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Image'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009a16), // Green color
                  foregroundColor: Colors.white, // White text
                ),
              ),
              const SizedBox(height: 20),

              // Display Image if available
              if (_imageFile != null)
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  child: ClipOval(
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Food Description
              TextFormField(
                controller: _foodDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Food Description',
                  hintText: 'Enter food details',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Food description is required';
                  }
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Donation Date Input (Date Picker Button)
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _donationDateController,
                    decoration: const InputDecoration(
                      labelText: 'Donation Date',
                      hintText: 'Pick a donation date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Donation date is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button (Upload)
              ElevatedButton(
                onPressed: _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009a16), // Green color
                ),
                child: const Text(
                  'Upload',
                  style: TextStyle(color: Colors.white), // White text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
