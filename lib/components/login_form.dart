import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kavach/components/login_incorrect.dart';
import 'package:kavach/pages/forget_pass.dart';
import 'package:kavach/pages/homepage.dart';
import 'package:kavach/pages/otp_request_pass.dart'; // Ensure this path is correct

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonDisabled = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _isButtonDisabled = _emailController.text.isEmpty || _passwordController.text.isEmpty;
    });
  }

  void _login() async { 
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to the homepage if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // Show an alert dialog if login fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LoginIncorrect();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _emailController,
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
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: _isButtonDisabled ? null : _login,
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
                borderRadius: BorderRadius.circular(20), // Rounded corners with a radius of 8
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: _isButtonDisabled ? Colors.grey : Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 35),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AskEmailForOTP(),
                ),
              );
            },
            child: Text(
              'Forget Password?',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 12 : 17,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
