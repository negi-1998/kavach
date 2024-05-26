import 'package:flutter/material.dart';
import 'package:kavach/pages/change_password.dart';

class ForgetPassword extends StatefulWidget {
  final String otp;
  final String email;
  const ForgetPassword({
    Key? key,
    required this.otp,
    required this.email,
  }) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  int _attemptsLeft = 3;
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOTP() {
    String enteredOTP = otpControllers.map((controller) => controller.text).join();
    if (enteredOTP == widget.otp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification successful')),
      );

      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => ChangePassword(email: widget.email,),
        )
      );
    } else {
      setState(() {
        _attemptsLeft--;
        if (_attemptsLeft == 0) {
          _isButtonDisabled = true;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect OTP. Attempts left: $_attemptsLeft')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    double squareSize = (screenSize.width - 32) / 4;

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
                      padding: const EdgeInsets.all(2),
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
                          const SizedBox(height: 80),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              'Enter the OTP sent to your email address',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 10 : 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int i = 0; i < 4; i++)
                                Container(
                                  width: squareSize,
                                  height: squareSize,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: otpControllers[i],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: squareSize * 0.5,
                                      color: Colors.white,
                                    ),
                                    cursorHeight: squareSize * 0.5,
                                    cursorWidth: 2,
                                    cursorColor: Colors.white,
                                    showCursor: true,
                                    keyboardType: TextInputType.number,
                                    maxLength: 1,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty && i < 3) {
                                        FocusScope.of(context).nextFocus();
                                      } else if (value.isEmpty && i > 0) {
                                        FocusScope.of(context).previousFocus();
                                      }
                                    },
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          GestureDetector(
                            onTap: _isButtonDisabled ? null : _verifyOTP,
                            child: Container(
                              height: 50,
                              width: squareSize * 3,
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
                                  'Verify',
                                  style: TextStyle(
                                    color: _isButtonDisabled ? Colors.grey : Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (_isButtonDisabled)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'You have exceeded the maximum number of attempts. Please generate a new OTP.',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: isSmallScreen ? 12 : 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
