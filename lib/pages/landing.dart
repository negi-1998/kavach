import 'package:flutter/material.dart';
import 'package:kavach/components/login_form.dart';
import 'package:kavach/components/signup_form.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  FontWeight loginFontWeight = FontWeight.normal;
  FontWeight signupFontWeight = FontWeight.w300;
  bool loginClicked = true;

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
                      width: double.infinity,
                      height: double.infinity,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    loginFontWeight = FontWeight.normal;
                                    signupFontWeight = FontWeight.w300;
                                    loginClicked = true;
                                  });
                                },
                                child: Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 15 : 25,
                                    fontWeight: loginFontWeight,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    signupFontWeight = FontWeight.normal;
                                    loginFontWeight = FontWeight.w300;
                                    loginClicked = false;
                                  });
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isSmallScreen ? 15 : 25,
                                    fontWeight: signupFontWeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          
                          if (loginClicked)
                            const LoginForm(),
                          if (!loginClicked)
                            const SignupForm(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
