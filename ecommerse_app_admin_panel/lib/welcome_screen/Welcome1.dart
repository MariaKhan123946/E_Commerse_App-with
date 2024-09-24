import 'package:ecommerse_app_admin_panel/auth/login.dart';
import 'package:flutter/material.dart';

class StoreWelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80), // Spacing from top

          // Logo and Title
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'images/img_1.png', // Replace with your logo path
                  height: 80,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Rich Text for Deshi Mart
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'DESHI ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                      TextSpan(
                        text: 'MART',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Orange color for "Mart"
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Desh ka market',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),

          // Features List with Divider
          featureItem(
            Image.asset('images/mdiorganic.png', height: 28),
            text: 'Organic Groceries',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
          featureItem(
            Image.asset('images/mdifoody.png', height: 28),
            text: 'Whole foods and vegetable',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
          featureItem(
            Image.asset('images/hugeicons.png', height: 28),
            text: 'Fast Delivery',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
          featureItem(
            Image.asset('images/solarmoney.png', height: 28),
            text: 'Easy Refund and Return',
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
          featureItem(
            Image.asset('images/img_13.png', height: 28),
            text: 'Secure and Safe',
          ),

          SizedBox(height: 20),

          // Bottom Section
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xff00CA44),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Welcome to our Store',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    'Get your grocery in as fast as\n                 one hour',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Search Field or Button
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NectarLoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Color(0xff00CA44),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget featureItem(Image image, {required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40),
          image, // Display the image
          SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
