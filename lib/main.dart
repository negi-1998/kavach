import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kavach/firebase_options.dart';
import 'package:kavach/pages/homepage.dart';
import 'package:kavach/pages/landing.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KAVACH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}


