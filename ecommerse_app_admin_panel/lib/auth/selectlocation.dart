import 'package:ecommerse_app_admin_panel/auth/logging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
 // Import your LoginScreen

class LocationSelectScreen extends StatefulWidget {
  @override
  _LocationSelectScreenState createState() => _LocationSelectScreenState();
}

class _LocationSelectScreenState extends State<LocationSelectScreen> {
  String? selectedZone;
  String? selectedArea;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to save location data to Firestore
  Future<void> _saveLocationToFirestore() async {
    if (selectedZone != null && selectedArea != null) {
      try {
        // Save selected zone and area to Firestore (e.g., under a 'locations' collection)
        await _firestore.collection('locations').add({
          'zone': selectedZone,
          'area': selectedArea,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location saved successfully!')),
        );

        // Navigate to LoginScreen after successful save
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save location: $e')),
        );
      }
    } else {
      // Show error message if zone/area is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both zone and area')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'images/mapicon.png', // Replace with your map icon image path
              height: 150,
              width: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Select Your Location',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Switch on your location to stay in tune with what\'s happening in your area',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Your Zone',
              ),
              items: ['Banasree', 'Gulshan', 'Uttara']
                  .map((zone) => DropdownMenuItem(
                value: zone,
                child: Text(zone),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedZone = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Your Area',
                hintText: 'Types of your area',
              ),
              items: ['Area 1', 'Area 2', 'Area 3']
                  .map((area) => DropdownMenuItem(
                value: area,
                child: Text(area),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                });
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveLocationToFirestore(); // Save to Firestore
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff53B175),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
