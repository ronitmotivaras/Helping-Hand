import 'package:flutter/material.dart';
import 'newpassoword.dart'; // Import the NewPasswordScreen (you need to create this screen)

void main() {
  runApp(const MaterialApp(
    home: ForgotPasswordScreen(),
  ));
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isOtpSent = false; // Flag to show OTP-related UI
  bool isOtpCorrect = false; // Flag to check if entered OTP is correct

  // Fake OTP for demonstration (you can replace this with actual logic)
  String otp = '123456';

  // Function to validate mobile number length (should be 10 digits)
  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10) {
      return 'Mobile number should be 10 digits';
    }
    return null;
  }

  // Function to send OTP (for demonstration purposes, we'll just print the mobile number)
  void _sendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isOtpSent = true; // Show OTP input and button after sending OTP
      });
      // Logic to send OTP would go here, e.g., API call
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to your mobile number')),
      );
    }
  }

  // Function to validate OTP
  void _validateOtp() {
    // Check if OTP is exactly 6 digits
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP must be 6 digits')),
      );
      return;
    }

    // Check if OTP matches the predefined (fake) OTP
    if (otpController.text == otp) {
      setState(() {
        isOtpCorrect = true; // OTP is correct
      });
      // Navigate to new password screen after successful OTP verification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified successfully. Redirecting to New Password screen...')),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
        );
      });
    } else {
      setState(() {
        isOtpCorrect = false; // OTP is incorrect
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entered wrong OTP, please try again.')),
      );
    }
  }

  // Function to resend OTP
  void _resendOtp() {
    setState(() {
      otpController.clear(); // Clear OTP field
      isOtpCorrect = false; // Reset OTP check
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP has been resent to your mobile number.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: const Color(0xFF009a16), // Green color for navbar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side "Forgot Password"
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF009a16), // Green color for text
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Form for entering registered mobile number
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Mobile number input
                  TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Enter Registered Mobile Number',
                      hintText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone, color: Colors.green),
                    ),
                    validator: _validateMobileNumber, // Validate the mobile number
                  ),
                  const SizedBox(height: 20),

                  // Send OTP Button
                  ElevatedButton(
                    onPressed: _sendOtp, // Call send OTP function
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009a16), // Green color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Show OTP field and resend option after OTP is sent
                  if (isOtpSent) ...[
                    const Text(
                      'OTP sent to your registered mobile number',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    // OTP input field
                    TextFormField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter OTP',
                        hintText: 'OTP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Resend OTP button
                    GestureDetector(
                      onTap: _resendOtp, // Resend OTP functionality
                      child: const Text(
                        'Resend OTP?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Verify OTP Button
                    ElevatedButton(
                      onPressed: _validateOtp, // Verify OTP
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009a16), // Green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Verify OTP',
                        style: TextStyle(fontSize: 18, color: Colors.white), // White text color
                      ),
                    ),
                  ],

                  // Display Sign In button if OTP is correct
                  if (isOtpCorrect) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009a16), // Green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Set New Password',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
