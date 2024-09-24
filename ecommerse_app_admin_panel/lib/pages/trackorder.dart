import 'package:ecommerse_app_admin_panel/welcome_screen/orderfaileddialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId; // Pass the order ID to track a specific order.

  TrackOrderScreen({required this.orderId});

  Future<void> trackOrder(BuildContext context) async {
    try {
      // Fetch order status from Firestore
      DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;
        print('Order Status: ${orderData['status']}');
        // Implement further logic based on order status.
      } else {
        // If the order is not found, navigate to the ErrorScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ErrorScreen(

            ),
          ),
        );
      }
    } catch (e) {
      // Navigate to the ErrorScreen in case of any errors
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorScreen(

          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'images/img_4.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/img_8.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
                Text(
                  'Your Order has been\n accepted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your items have been placed and are\non their way to being processed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xff7C7C7C)),
                ),
                SizedBox(height: 120),
                SizedBox(
                  height: 55,
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () async {
                      await trackOrder(context); // Call the track order function and pass context
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff53B175),
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Track Order',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 55,
                  width: 280,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
