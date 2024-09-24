import 'dart:async'; // Import the timer package
import 'package:ecommerse_app_admin_panel/welcome_screen/Welcome1.dart';
import 'package:flutter/material.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {

  @override
  void initState() {
    super.initState();

    // Set the timer for the splash screen duration
    Timer(Duration(seconds: 5), () {
      // Navigate to StoreWelcomeScreen after the timer ends
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StoreWelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00CA44),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
             Image.asset(
                'images/spalce.png',
                height: 100,
              ),

            SizedBox(height: 5),
            Text(
              'DESHI MART',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xffFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

