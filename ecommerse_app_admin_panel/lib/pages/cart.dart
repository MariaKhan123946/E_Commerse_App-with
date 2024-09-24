import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_app_admin_panel/pages/cartitem.dart';
import 'package:ecommerse_app_admin_panel/pages/checkoutrow.dart';
import 'package:flutter/material.dart';
import 'payment card.dart';
import 'trackorder.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCheckoutVisible = false;
  List<CartItem> cartItems = [];

  double getTotalPrice(List<CartItem> cartItems) {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> placeOrder(List<CartItem> cartItems) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('orders').add({
      'products': cartItems.map((item) => {
        'productName': item.name,
        'price': item.price.toString(),
        'quantity': item.quantity,
      }).toList(),
      'totalPrice': getTotalPrice(cartItems),
      'status': 'Processing',
      'orderDate': Timestamp.now(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrackOrderScreen(orderId: '',)),
    );
  }

  void removeItemFromCart(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('cart').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('Your cart is empty'));
              }

              cartItems = snapshot.data!.docs.map((doc) {
                double price = double.parse(doc['price'].replaceAll('\$', ''));

                return CartItem(
                  doc['productName'],
                  '1kg, Price',
                  price,
                  doc['image'],
                  quantity: doc['quantity'],
                );
              }).toList();

              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Container(
                          child: Image.asset(cartItems[index].image, errorBuilder: (context, error, stackTrace) {
                            return Image.network('https://default_image_url_here',height: 70,width: 70,); // Fallback for asset loading
                          }),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cartItems[index].name),
                            GestureDetector(
                              onTap: () => removeItemFromCart(index),
                              child: Icon(Icons.close, color: Colors.grey),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('1kg, Price'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => decreaseQuantity(index),
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                          borderRadius: BorderRadius.circular(13),
                                            border: Border.all(color: Color(0xffE2E2E2))
                                        ),
                                        child: Icon(Icons.remove, size: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text('${cartItems[index].quantity}'),
                                    ),
                                    GestureDetector(
                                      onTap: () => increaseQuantity(index),
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                          borderRadius: BorderRadius.circular(13),
                                          border: Border.all(color: Color(0xffE2E2E2))
                                        ),
                                        child: Icon(Icons.add, size: 18,color: Colors.green,),
                                      ),
                                    ),
                                  ],
                                ),
                                Text('\$${cartItems[index].price}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(thickness: 1,),
                    ],
                  );
                },
              );
            },
          ),
          if (!isCheckoutVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:  Padding(
                padding: const EdgeInsets.only(left: 30,right: 30),
                child: SizedBox(
                       height: 50,
                       width: 250,
                        child:
                     ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isCheckoutVisible = true;
                      });
                    },
                    child: Center(child: Text('Go to Checkout',style: TextStyle(color: Colors.white,fontSize: 12),)),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Color(0xff53B175),
                         padding: EdgeInsets.symmetric(vertical: 18),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(12),
                         ),
                       ),
                ),
              ),
            ),
            ),
          if (isCheckoutVisible)
            Container(
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: CheckoutSection(
                      totalPrice: getTotalPrice(cartItems),
                      onPlaceOrder: () => placeOrder(cartItems),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation between tabs
        },
      ),
    );
  }
}

class CheckoutSection extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPlaceOrder;

  CheckoutSection({required this.totalPrice, required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('Checkout', style: TextStyle(fontSize: 25, color: Colors.black)),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close the checkout section
              },
              child: Icon(Icons.close, color: Colors.black, size: 20),
            ),
          ],
        ),
        Divider(thickness: 1.0, color: Colors.grey.shade300),
        // Delivery method section
        CheckoutRow(
          label: 'Delivery',
          value: 'Select Method',
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 200,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Home Delivery'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Pick Up'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        Divider(thickness: 1.0, color: Colors.grey.shade300),
        // Payment method section
        CheckoutRow(
          label: 'Payment',
          value: 'MasterCard',
          icon: Icon(Icons.credit_card, color: Colors.blue),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 200,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.credit_card),
                        title: Text('MasterCard'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MySample(),));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.payment),
                        title: Text('Visa'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        Divider(thickness: 1.0, color: Colors.grey.shade300),
        // Promo Code section
        CheckoutRow(
          label: 'Promo Code',
          value: 'Pick discount',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Enter Promo Code'),
                  content: TextField(
                    decoration: InputDecoration(hintText: "Promo Code"),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Apply'),
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        Divider(thickness: 1.0, color: Colors.grey.shade300),
        CheckoutRow(
          label: 'Total Cost',
          value: '\$$totalPrice',
          isBold: true,
          onTap: () {},
        ),
        Divider(thickness: 1.0, color: Colors.grey.shade300),
        SizedBox(height: 5),
        Row(
          children: [
            Text(
              'By placing an order you agree to our\nTerms And Conditions',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(height: 9),
        SizedBox(
          height: 50,
          width: 300,
          child: ElevatedButton(
            onPressed: onPlaceOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff53B175),
              padding: EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: Text('Place Order', style: TextStyle(fontSize: 12,color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
