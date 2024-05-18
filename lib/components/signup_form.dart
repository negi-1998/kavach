import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kavach/components/ac_exists.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _areDetailsFilled = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _mobileNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isPasswordValid.dispose();
    _areDetailsFilled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onChanged: (_) => _validateDetails(),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _usernameController,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'E-mail',
                hintStyle: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onChanged: (_) => _validateDetails(),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _mobileNumberController,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                color: Colors.white,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Mobile Number',
                hintStyle: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onChanged: (_) => _validateDetails(),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Password (At least 8 characters long)',
                hintStyle: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
              onChanged: (value) {
                _isPasswordValid.value = value.length >= 8;
                _validateDetails();
              },
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<bool>(
              valueListenable: _isPasswordValid,
              builder: (context, isValid, child) {
                return TextField(
                  controller: _confirmPasswordController,
                  enabled: isValid,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 20,
                    color: isValid ? Colors.white : Colors.grey,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Re-enter Password',
                    hintStyle: TextStyle(
                      fontSize: isSmallScreen ? 16 : 20,
                      fontWeight: FontWeight.w300,
                      color: isValid ? Colors.white : Colors.grey,
                    ),
                  ),
                  onChanged: (value) => _validateDetails(),
                );
              },
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder<bool>(
              valueListenable: _areDetailsFilled,
              builder: (context, areDetailsFilled, _) {
                return GestureDetector(
                  onTap: areDetailsFilled ? _signup : null,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 13, 71, 161), // Dark blue
                          Colors.blueGrey, // Light blue
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          color: areDetailsFilled ? Colors.white : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom), // Adjust for keyboard
          ],
        ),
      ),
    );
  }

  void _validateDetails() {
    _areDetailsFilled.value = _nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _mobileNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _isPasswordValid.value &&
        _passwordController.text == _confirmPasswordController.text;
  }

  void _signup() async {
    try {
      // Check if user already exists
      final userExists = await _checkIfUserExists(_mobileNumberController.text);
      print("insdie userexists of signup");
      if (userExists) {
        showDialog(
          context: context,
          builder: (context) => const AlreadyExists(),
        );
        return;
      }

      // Create a user with email and password
      print("before crating user");
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      // Save user details to Firestore
      print('before saving details');
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'name': _nameController.text,
        'email': _usernameController.text,
        'mobileNumber': _mobileNumberController.text,
      });

      // Show a success message or navigate to the next screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful!')),
      );
    } catch (error) {
      print('Error signing up: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error signing up. Please try again later.')),
      );
    }
  }

  Future<bool> _checkIfUserExists(String mobileNumber) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('mobileNumber', isEqualTo: mobileNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking user existence: $error');
      return false;
    }
  }

}


