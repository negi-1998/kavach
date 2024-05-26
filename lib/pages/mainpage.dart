import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isPressed = false;
  final String _emergencyContact = '+917455966744';

  Future<void> _sendEmergencyMessage() async {
    try {
      // Check and request permissions
      await _checkPermissions();

      // Get current location
      Position position = await _determinePosition();

      // Construct the message with location
      String message =
          'Hey, I am in trouble. Need your help at https://maps.google.com/?q=${position.latitude},${position.longitude}.';

      // Send SMS
      await _sendSMS(message, [_emergencyContact]);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency message sent successfully!')),
      );
    } catch (e) {
      // Show failure snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send emergency message: $e')),
      );
    }
  }

  Future<void> _checkPermissions() async {
    await [
      Permission.location,
      Permission.sms,
    ].request();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendSMS(String message, List<String> recipients) async {
    try {
      String result = await sendSMS(message: message, recipients: recipients);
      print(result);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _isPressed = true;
                  });
                },
                onTapUp: (_) async {
                  setState(() {
                    _isPressed = false;
                  });
                  await _sendEmergencyMessage();
                },
                onTapCancel: () {
                  setState(() {
                    _isPressed = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        Color.fromARGB(255, 204, 111, 111),
                        Color.fromARGB(255, 198, 15, 2),
                      ],
                      center: Alignment.center,
                      radius: 1.0,
                    ),
                    boxShadow: _isPressed
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.6,
                  child: Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        fontSize: _isPressed ? screenWidth * 0.1 : screenWidth * 0.12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              'Your emergency contacts',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            buildContactCard('Papa', '+917455966744'),
            SizedBox(height: screenHeight * 0.04),
            buildContactCard('Mummy', '+917455966744'),
            SizedBox(height: screenHeight * 0.04),
            buildContactCard('Pookie', '+917455966744'),
          ],
        ),
      ),
    );
  }

  Widget buildContactCard(String name, String phoneNumber) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          phoneNumber,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        leading: const Icon(
          Icons.person,
          size: 40,
          color: Colors.blue,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone),
          onPressed: () {
            _makePhoneCall(phoneNumber);
          },
        ),
      ),
    );
  }
}
