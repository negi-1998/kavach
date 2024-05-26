import 'package:flutter/material.dart';
import 'package:kavach/pages/mainpage.dart';
import 'package:kavach/pages/mythreats.dart';
import 'package:kavach/pages/profile_page.dart';
import 'package:kavach/pages/safety_posts.dart';
import 'package:kavach/pages/threatpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Default index set to 0

  final List<Widget> _pages = [
    const MainPage(),
    const ThreatsPage(),
    const MyThreatsPage(),
    const SafetyPostsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  'KAVACH',
                  style: TextStyle(color: Colors.black, fontSize: 35),
                  //overflow: TextOverflow.ellipsis,
                ),
              )
            )
          ],
        ),
      ),
      body: SafeArea(
        child: _pages[_selectedIndex], // Display the selected page directly
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.push_pin),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
