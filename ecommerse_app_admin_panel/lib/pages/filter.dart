import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FilterScreen(),
    );
  }
}

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Track selected filters
  Map<String, bool> categories = {
    "Eggs": true,
    "Noodles & Pasta": false,
    "Chips & Crisps": false,
    "Fast Food": false,
  };

  Map<String, bool> brands = {
    "Individual Collection": false,
    "Cocola": true,
    "Ifad": false,
    "Kazi Farmas": false,
  };

  @override
  void initState() {
    super.initState();
    fetchFilters();
  }

  Future<void> fetchFilters() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('filters').doc('userFilters').get();
      if (doc.exists) {
        setState(() {
          categories = Map<String, bool>.from(doc['categories']);
          brands = Map<String, bool>.from(doc['brands']);
        });
      }
    } catch (e) {
      print('Error fetching filters: $e');
    }
  }

  Future<void> saveFilters() async {
    try {
      await FirebaseFirestore.instance.collection('filters').doc('userFilters').set({
        'categories': categories,
        'brands': brands,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Filters saved successfully!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error saving filters: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error saving filters. Please try again.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Filters", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Section
            Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...categories.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key, style: TextStyle(color: categories[key]! ? Colors.green : Colors.black)),
                value: categories[key],
                activeColor: Colors.green,
                onChanged: (bool? value) {
                  setState(() {
                    categories[key] = value!;
                  });
                },
              );
            }).toList(),

            SizedBox(height: 20),

            // Brand Section
            Text("Brand", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...brands.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key, style: TextStyle(color: brands[key]! ? Colors.green : Colors.black)),
                value: brands[key],
                activeColor: Colors.green,
                onChanged: (bool? value) {
                  setState(() {
                    brands[key] = value!;
                  });
                },
              );
            }).toList(),

            Spacer(),

            // Apply Filter Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    saveFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Apply Filter",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
