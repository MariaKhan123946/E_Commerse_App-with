import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  // This function triggers the OrderFailedDialog
  void showOrderFailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderFailedDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Favourite',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: false, // Hide the default back button
        bottom: PreferredSize(
          child: Divider(thickness: 2, height: 2, color: Colors.grey[300]),
          preferredSize: Size.fromHeight(1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/sprite_can.png', // Replace with your asset path
                  height: 50,
                  width: 50,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sprite Can',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 5),
                          Text(
                            '325ml',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$1.50',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(Icons.arrow_back_ios_outlined, size: 16, color: Colors.black),
              ],
            ),
            Divider(thickness: 2, height: 30, color: Colors.grey[300]), // Divider after the row
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Call the function to show the dialog
                  showOrderFailedDialog(context);
                },
                child: Text('Show Order Failed Dialog'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}

// Dialog Widget for Order Failed
class OrderFailedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        height: 400.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
              Image.asset(
                'images/img_11.png', // Replace with your asset path
                height: 120.0,
              ),
              SizedBox(height: 20.0),
              Text(
                "Oops! Order Failed",
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Something went terribly wrong.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Retry logic can be implemented here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Please Try Again",
                  style: TextStyle(fontSize: 16.0,color: Colors.white),
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back to home
                },
                child: Text(
                  "Back to home",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
