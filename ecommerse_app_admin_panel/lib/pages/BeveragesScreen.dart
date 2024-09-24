import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BeveragesScreen(),
    );
  }
}

class BeveragesScreen extends StatelessWidget {
  const BeveragesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> beverages = [
      {'name': 'Diet Coke', 'size': '355ml', 'price': 1.99, 'image': 'images/diet_coke.png'},
      {'name': 'Sprite Can', 'size': '325ml', 'price': 1.50, 'image': 'images/sprite_can.png'},
      {'name': 'Apple & Grape', 'size': '2L', 'price': 15.99, 'image': 'images/apple_grape.png'},
      {'name': 'Orange Juice', 'size': '2L', 'price': 15.99, 'image': 'images/orange_juice.png'},
      {'name': 'Coca Cola Can', 'size': '325ml', 'price': 4.99, 'image': 'images/coca_cola.png'},
      {'name': 'Pepsi Can', 'size': '330ml', 'price': 4.99, 'image': 'images/pepsi_can.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black, size: 20),
          onPressed: () {},
        ),
        centerTitle: true,
        title: const Text(
          "Beverages",
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Image.asset('images/img_6.png', height: 20),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.75,
          ),
          itemCount: beverages.length,
          itemBuilder: (context, index) {
            return buildBeverageCard(context, beverages[index]);
          },
        ),
      ),
    );
  }

  Widget buildBeverageCard(BuildContext context, Map<String, dynamic> beverage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                beverage['image'],
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              beverage['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              '${beverage['size']}, Price',
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  '\$${beverage['price']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    addBeverageToFirestore(context, beverage);
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xff53B175),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addBeverageToFirestore(BuildContext context, Map<String, dynamic> beverage) async {
    try {
      await FirebaseFirestore.instance.collection('beverages').add(beverage);
      print('Beverage added to Firestore: ${beverage['name']}');

      // Show a message in the ScaffoldMessenger
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${beverage['name']} added to the category!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding beverage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error adding beverage. Please try again.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
