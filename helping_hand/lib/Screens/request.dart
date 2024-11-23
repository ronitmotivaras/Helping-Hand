import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

class RequestFoodScreen extends StatefulWidget {
  @override
  _RequestFoodScreenState createState() => _RequestFoodScreenState();
}

class _RequestFoodScreenState extends State<RequestFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _donationDateController = TextEditingController();
  TextEditingController _minimumQuantityController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

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
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  // Submit the request details
  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      // Handle the submission logic (e.g., uploading to Firestore or backend)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request Submitted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Food'),
        backgroundColor: const Color(0xFF009a16), // Green color for navbar
        foregroundColor: Colors.white, // White text color in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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

              // Minimum Quantity (Compulsory)
              TextFormField(
                controller: _minimumQuantityController,
                decoration: const InputDecoration(
                  labelText: 'Minimum Quantity',
                  hintText: 'Enter minimum quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Minimum quantity is required';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description (Optional)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter any additional details',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Request Button
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF009a16), // Green color
                ),
                child: const Text(
                  'Request',
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
