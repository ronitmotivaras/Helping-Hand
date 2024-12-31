import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  // Define controllers and error variables
  TextEditingController fnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  String? fnameError, mobileError, passwordError, confirmPasswordError, addressError, cityError, userTypeError;
  String? userType;
  bool isLoading = false;

  void addData() async {
    setState(() {
      // Reset error messages
      fnameError = null;
      mobileError = null;
      passwordError = null;
      confirmPasswordError = null;
      addressError = null;
      cityError = null;
      userTypeError = null;
    });

    String name = fnameController.text.trim();
    String mobile = mobileController.text.trim();
    String password = passController.text.trim();
    String confirmPassword = confirmPassController.text.trim();
    String address = addressController.text.trim();
    String city = cityController.text.trim();

    bool isValid = true;

    // Full Name Validation
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(name)) {
      fnameError = "Full Name can only contain alphabets";
      isValid = false;
    }

    // Mobile Number Validation
    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      mobileError = "Enter a valid 10-digit mobile number";
      isValid = false;
    }

    // Password Validation
    if (!RegExp(r'^[a-zA-Z0-9@]{6,}$').hasMatch(password)) {
      passwordError = "Password must be at least 6 characters and include alphanumeric and '@'";
      isValid = false;
    }

    // Confirm Password Validation
    if (password != confirmPassword) {
      confirmPasswordError = "Passwords do not match";
      isValid = false;
    }

    // Address Validation
    if (address.isEmpty) {
      addressError = "Address cannot be empty";
      isValid = false;
    }

    // City Validation
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(city)) {
      cityError = "City can only contain alphabets";
      isValid = false;
    }

    // User Type Validation
    if (userType == null) {
      userTypeError = "Please select a user type";
      isValid = false;
    }

    if (!isValid) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection("Users").add({
        "Name": name,
        "Mobile": mobile,
        "Password": password,
        "Address": address,
        "City": city,
        "UserType": userType,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful! Please log in.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register: $error")),
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
        title: const Text("Registration"),
        backgroundColor: const Color(0xFF009a16),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name Field
              TextField(
                controller: fnameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  errorText: fnameError,
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

              // Mobile Number Field
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Mobile Number",
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
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
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
              const SizedBox(height: 20),

              // Confirm Password Field
              TextField(
                controller: confirmPassController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  errorText: confirmPasswordError,
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

              // Address Field
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Address",
                  errorText: addressError,
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

              // City Field
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: "City",
                  errorText: cityError,
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

              // User Type Selection (Dropdown)
              Row(
                children: [
                  const Text("User Type: "),
                  DropdownButton<String>(
                    value: userType,
                    hint: const Text("Select User Type"),
                    onChanged: (value) {
                      setState(() {
                        userType = value;
                      });
                    },
                    items: <String>['Donator', 'Needy', 'Organization']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF009a16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: const Size(40, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
