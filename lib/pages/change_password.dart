import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kavach/pages/homepage.dart';
import 'package:kavach/pages/landing.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordValid = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _areDetailsFilled = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _passwordController.dispose();
    _rePasswordController.dispose();
    _isPasswordValid.dispose();
    _areDetailsFilled.dispose();
    super.dispose();
  }

  void _validateDetails() {
    _areDetailsFilled.value = _passwordController.text.isNotEmpty &&
        _rePasswordController.text.isNotEmpty &&
        _passwordController.text == _rePasswordController.text &&
        _isPasswordValid.value;
  }

  Future<void> _changePassword() async {
    print("inside button");
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(_passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password successfully changed!'),
          ),
        );
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => const LandingPage(),
          )
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user is currently signed in.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password change failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.blue[900]!,
                            Colors.red,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 100),
                          Text(
                            'KAVACH',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 30 : 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Your virtual shield',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 10 : 20,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            onChanged: (value) {
                              _isPasswordValid.value = value.length >= 8;
                              _validateDetails();
                            },
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Enter new password',
                              hintStyle: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ValueListenableBuilder<bool>(
                            valueListenable: _isPasswordValid,
                            builder: (context, isValid, child) {
                              return TextField(
                                controller: _rePasswordController,
                                enabled: isValid,
                                obscureText: true,
                                onChanged: (value) {
                                  _validateDetails();
                                },
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 20,
                                  color: isValid ? Colors.white : Colors.grey,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Re-enter new password',
                                  hintStyle: TextStyle(
                                    fontSize: isSmallScreen ? 16 : 20,
                                    color: isValid ? Colors.white : Colors.grey,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          ValueListenableBuilder<bool>(
                            valueListenable: _areDetailsFilled,
                            builder: (context, areDetailsFilled, _) {
                              return GestureDetector(
                                onTap: areDetailsFilled ? _changePassword : null,
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 13, 71, 161),
                                        Colors.blueGrey,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Change Password',
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
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
