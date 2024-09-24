import 'package:ecommerse_app_admin_panel/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, String> product;

  DetailScreen({required this.product});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1; // Variable to store the quantity of the product
  bool showProductDetails = false; // Toggle for showing product details
  bool showNutrition = false; // Toggle for showing nutrition info

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Icons
            Container(
              height: 300,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  // Image
                  Center(
                    child: Image.asset(
                      widget.product['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Back and Download Icons
                  Positioned(
                    top: 5,
                    left: 0,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.black, size: 15),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 0,
                    child: IconButton(
                      icon: Image.asset('images/Vector.png', height: 20),
                      onPressed: () {
                        // Add download functionality here
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Product Name and Favorite Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product['name']!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.favorite_border, color: Colors.red),
                ],
              ),
            ),
            SizedBox(height: 8),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '1kg, price',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            SizedBox(height: 16),

            // Quantity Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _quantityButton(Icons.remove, () {
                    setState(() {
                      if (quantity > 1) quantity--;
                    });
                  }),
                  SizedBox(width: 16),
                  Text('$quantity', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 16),
                  _quantityButton(Icons.add, () {
                    setState(() {
                      quantity++;
                    });
                  }),
                  Spacer(),
                  Text(
                    '${widget.product['price']!}',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Product Detail Section
            _buildExpandableSection(
              title: 'Product Detail',
              content:
              'Apples are nutritious. Apples may be good for weight loss. Apples may be good for your heart. As part of a healthy and varied diet.',
              isExpanded: showProductDetails,
              onTap: () {
                setState(() {
                  showProductDetails = !showProductDetails;
                });
              },
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),
            SizedBox(height: 16),

            // Nutrition Information
            _buildExpandableSection(
              title: 'Nutritions',
              content: 'Calories: 95, Carbohydrates: 25g, Fiber: 4g, Sugars: 19g, Vitamin C: 14%',
              isExpanded: showNutrition,
              onTap: () {
                setState(() {
                  showNutrition = !showNutrition;
                });
              },
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),
            SizedBox(height: 16),

            // Reviews Section
            _buildReviewsSection(),
            SizedBox(height: 40,),

            // Add to Basket Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Add to cart functionality
                  await FirebaseFirestore.instance.collection('cart').add({
                    'productName': widget.product['name'],
                    'price': widget.product['price'],
                    'image': widget.product['image'],
                    'quantity': quantity,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to cart')));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },

                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Add To Basket',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff53B175),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String content,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                content,
                style: TextStyle(color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star, color: Colors.yellow),
              Icon(Icons.star_half, color: Colors.yellow),
              Icon(Icons.arrow_forward_ios, size: 12),
            ],
          ),
        ],
      ),
    );
  }
}
