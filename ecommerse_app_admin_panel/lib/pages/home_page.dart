import 'package:ecommerse_app_admin_panel/pages/detail.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> exclusiveOfferProducts = [
    {'name': 'Naturel Red Apple', 'price': '\$2.99', 'image': 'images/apple.png'},
    {'name': 'Organic Bananas', 'price': '\$1.99', 'image': 'images/banana.png'},
  ];

  final List<Map<String, String>> bestSellingProducts = [
    {'name': 'Bell Pepper Red', 'price': '\$0.99', 'image': 'images/Bell Pepper Red.png'},
    {'name': 'Sweet Ginger', 'price': '\$1.49', 'image': 'images/Ginger.png'},
  ];

  final List<Map<String, String>> groceries = [
    {'name': 'Fresh Pulses', 'price': '\$4.99', 'image': 'images/Pulses.png'},
    {'name': 'Chicken Rice', 'price': '\$5.99', 'image': 'images/Rice.png'},
    {'name': 'Fresh Beef Bone', 'price': '\$1.99', 'image': 'images/Beef Bone.png'},
    {'name': 'Broiler Chicken', 'price': '\$2.49', 'image': 'images/Broiler Chicken.png'},
  ];

  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter products for exclusive offer only
  List<Map<String, String>> _filterExclusiveOfferProducts() {
    if (_searchText.isEmpty) {
      return exclusiveOfferProducts;
    } else {
      return exclusiveOfferProducts
          .where((product) => product['name']!.toLowerCase().contains(_searchText))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'images/img_7.png',
              height: 30,
            ),
            SizedBox(width: 65),
            Icon(Icons.location_on, color: Colors.black),
            SizedBox(width: 4),
            Text('Dhaka, Banassre', style: TextStyle(color: Colors.black, fontSize: 16)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey[400]),
                    hintText: "Search Exclusive Offers",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Banner Image
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('images/fresh_vegetables.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Exclusive Offer Section with search functionality
              sectionTitle('Exclusive Offer'),
              productGrid(context, _filterExclusiveOfferProducts()),
              SizedBox(height: 20),

              // Best Selling Section (unchanged, no search here)
              sectionTitle('Best Selling'),
              productGrid(context, bestSellingProducts),
              SizedBox(height: 20),

              // Groceries Section (unchanged, no search here)
              sectionTitle('Groceries'),
              groceryRow(context, groceries[0], groceries[1]),
              SizedBox(height: 16),
              productGrid(context, groceries.sublist(2)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: () {}, child: Text('See all')),
      ],
    );
  }

  Widget productGrid(BuildContext context, List<Map<String, String>> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return productItem(context, products[index]);
      },
    );
  }

  Widget groceryRow(BuildContext context, Map<String, String> firstProduct, Map<String, String> secondProduct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: groceryItem(context, firstProduct, color: Colors.green.shade50)),
        SizedBox(width: 16),
        Expanded(child: groceryItem(context, secondProduct, color: Colors.yellow.shade50)),
      ],
    );
  }

  Widget groceryItem(BuildContext context, Map<String, String> product, {Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Centering the content
        children: [
          Image.asset(
            product['image'] ?? 'images/product_image.png',
            height: 80,
          ),
          SizedBox(height: 8),
          Text(
            product['name'] ?? 'Product Name',
            textAlign: TextAlign.center, // Center the product name
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4), // Space between name and other elements if needed
        ],
      ),
    );
  }

  Widget productItem(BuildContext context, Map<String, String> product, {Color? color}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              product['image'] ?? 'images/product_image.png',
              height: 80,
            ),
            SizedBox(height: 8),
            Text(
              product['name'] ?? 'Product Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Text(
                '1kg, ${product['price']}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    product['price'] ?? '\$0.00',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xff53B175),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
