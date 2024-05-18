import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kavach/components/email_not_exist.dart';
import 'package:kavach/pages/forget_pass.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AskEmailForOTP extends StatefulWidget {
  const AskEmailForOTP({super.key});

  @override
  State<AskEmailForOTP> createState() => _AskEmailForOTPState();
}

class _AskEmailForOTPState extends State<AskEmailForOTP> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEMail);
  }

  void _validateEMail() {
    setState(() {
      _isButtonDisabled = _emailController.text.isEmpty;
    });
  }

  Future<void> _sendOTP() async{
    Random random = Random();
    String email = _emailController.text;
    try{
      final querySnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
      if(querySnapshot.docs.isEmpty) {
        showDialog(
          context: context, 
          builder: (context)=> const EmailNotExist()
        );
        return;
      }
      String otp = (1000 + (9999 - 1000) * (DateTime.now().millisecondsSinceEpoch % (100 + random.nextInt(900))) / ((10 + random.nextInt(90)))).toString().substring(0, 4);
      await _sendEmailOTP(email, otp);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to $email')
        )
      );
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const ForgetPassword()
        )
      );
    }

    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to send OTP. Try again later'))
      );
    }
  }

  Future<void> _sendEmailOTP(String email, String otp) async{
    String username = 'shashihmt98@gmail.com';
    String password = 'almjhuvuvowzhxuw';
    final SmtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Kavach')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is $otp';
    
    try{
      final sendReport = await send(message, SmtpServer);
      print('Message sent: ' + sendReport.toString());

    } on MailerException 
    catch(e){
      print('Message not sent. \n' + e.toString());
      for(var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Container(
                height: constraints.maxHeight,
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
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        Text(
                          'Enter your registered email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 10 : 20,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: _emailController,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 20,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your Registered E-mail',
                            hintStyle: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: _isButtonDisabled ? null : _sendOTP,
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
                                'Send OTP',
                                style: TextStyle(
                                  color: _isButtonDisabled
                                      ? Colors.grey
                                      : Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
