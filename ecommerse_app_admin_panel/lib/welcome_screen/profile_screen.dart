import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart'; // Add this for Firestore
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? currentUser;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _uploadedImageUrl;
  String? _username; // Store the fetched username here

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
      _uploadedImageUrl = currentUser?.photoURL; // Fetch uploaded image URL
    });

    // Fetch username from Firestore
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username']; // Make sure the field exists in Firestore
        });
      }
    }
  }

  Future<void> _editProfile() async {
    // Logic to edit profile, e.g., show a dialog to update user info
    final newName = await _showEditDialog('Enter your name', _username); // Use _username from Firestore
    if (newName != null && newName.isNotEmpty) {
      // Update Firestore with the new name
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'username': newName});

      _getUserData(); // Refresh user data
    }
  }

  Future<String?> _showEditDialog(String title, String? currentValue) async {
    TextEditingController controller = TextEditingController(text: currentValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter value'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadImage(pickedFile.path);
    }
  }

  Future<void> _uploadImage(String filePath) async {
    // Upload image to Firebase Storage
    final ref = _storage.ref().child('profile_pictures/${currentUser!.uid}.jpg');
    await ref.putFile(File(filePath));
    String downloadUrl = await ref.getDownloadURL();

    await currentUser?.updateProfile(photoURL: downloadUrl);
    _getUserData(); // Refresh user data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Account'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Profile Information with Divider Below
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _pickImage, // Pick image on tap
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: _uploadedImageUrl != null
                            ? NetworkImage(_uploadedImageUrl!)
                            : AssetImage('images/default_avatar.png') as ImageProvider,
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _username ?? 'Guest User', // Display fetched username
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          currentUser?.email ?? 'No Email',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _editProfile, // Edit functionality
                      icon: Icon(Icons.edit, color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Divider(),
              ],
            ),
          ),
          // List of Options
          Expanded(
            child: ListView(
              children: [
                _buildListItem(Icons.shopping_bag, 'Orders'),
                _buildListItem(Icons.person, 'My Details'),
                _buildListItem(Icons.location_on, 'Delivery Address'),
                _buildListItem(Icons.credit_card, 'Payment Methods'),
                _buildListItem(Icons.local_offer, 'Promo Code'),
                _buildListItem(Icons.notifications, 'Notifications'),
                _buildListItem(Icons.help_outline, 'Help'),
                _buildListItem(Icons.info_outline, 'About'),
              ],
            ),
          ),
          Divider(),
          // Log Out Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context); // Optionally navigate the user to login screen
              },
              icon: Icon(Icons.logout, color: Colors.green),
              label: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4, // Selected index
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Add navigation or action here
          },
        ),
        Divider(), // Divider below each list item
      ],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: ProfileScreen()));
}
