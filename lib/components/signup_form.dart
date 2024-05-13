import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
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
          ),
          const SizedBox(height: 30,),
          TextField(
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Username',
              hintStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          TextField(
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Mobile Number',
              hintStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          TextField(
            obscureText: true,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          TextField(
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Re-enter Password',
              hintStyle: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          GestureDetector(
            onTap: () {
              print('login button');
            },
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
              child: const Center(
                child: Text(
                  'Signup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}