// import 'package:flutter/material.dart';
//
// class CartScreen extends StatefulWidget {
//   @override
//   _CartScreenState createState() => _CartScreenState();
// }
//
// class _CartScreenState extends State<CartScreen> {
//   List<CartItem> cartItems = [
//     CartItem('Bell Pepper Red', '1kg, Price', 4.99, 'images/Bell Pepper Red.png'),
//     CartItem('Egg Chicken Red', '4pcs, Price', 1.99, 'images/egg_red.png'),
//     CartItem('Organic Bananas', '12kg, Price', 3.00, 'images/banana.png'),
//     CartItem('Fresh Ginger', '250gm, Price', 2.99, 'images/Ginger.png'),
//   ];
//
//   bool isCheckoutVisible = false;
//
//   double getTotalPrice() {
//     double total = 0;
//     for (var item in cartItems) {
//       total += item.price * item.quantity;
//     }
//     return total;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Cart'),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           if (isCheckoutVisible)
//             Container(
//               color: Colors.black54, // Light black background for the checkout section
//               padding: EdgeInsets.all(16.0),
//               child: CheckoutSection(totalPrice: getTotalPrice()),
//             ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     CartItemWidget(
//                       item: cartItems[index],
//                       onRemove: () {
//                         setState(() {
//                           cartItems.removeAt(index);
//                         });
//                       },
//                       onAdd: () {
//                         setState(() {
//                           cartItems[index].quantity++;
//                         });
//                       },
//                       onSubtract: () {
//                         setState(() {
//                           if (cartItems[index].quantity > 1) {
//                             cartItems[index].quantity--;
//                           }
//                         });
//                       },
//                     ),
//                     Divider(thickness: 1.0, color: Colors.grey.shade300),
//                   ],
//                 );
//               },
//             ),
//           ),
//           // if (!isCheckoutVisible) // Show button only if checkout section is not visible
//           //   Padding(
//           //     padding: const EdgeInsets.symmetric(horizontal: 20),
//           //     child: ElevatedButton(
//           //       onPressed: () {
//           //         setState(() {
//           //           isCheckoutVisible = true;
//           //         });
//           //       },
//           //       child: Text('Proceed to Checkout'),
//           //       style: ElevatedButton.styleFrom(
//           //         backgroundColor: Color(0xff53B175),
//           //         minimumSize: Size(double.infinity, 50),
//           //       ),
//           //     ),
//           //   ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Colors.green,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
//           BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
//           BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
//           BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
//         ],
//         currentIndex: 2,
//         onTap: (index) {
//           // Handle navigation between tabs
//         },
//       ),
//     );
//   }
// }
//
// class CheckoutSection extends StatelessWidget {
//   final double totalPrice;
//
//   CheckoutSection({required this.totalPrice});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Delivery Method Row
//         CheckoutRow(
//           label: 'Delivery',
//           value: 'Select Method',
//           onTap: () {
//             // Add navigation for delivery selection
//           },
//         ),
//         // Payment Method Row
//         CheckoutRow(
//           label: 'Payment',
//           value: 'MasterCard',
//           icon: Icon(Icons.credit_card, color: Colors.blue),
//           onTap: () {
//             // Add navigation for payment method selection
//           },
//         ),
//         // Promo Code Row
//         CheckoutRow(
//           label: 'Promo Code',
//           value: 'Pick discount',
//           onTap: () {
//             // Add navigation for promo code
//           },
//         ),
//         // Total Cost Row
//         CheckoutRow(
//           label: 'Total Cost',
//           value: '\$$totalPrice',
//           isBold: true,
//         ),
//         SizedBox(height: 16),
//         // Place Order Button
//         ElevatedButton(
//           onPressed: () {
//             // Handle place order action here
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             padding: EdgeInsets.symmetric(vertical: 18),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: Center(
//             child: Text(
//               'Place Order',
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class CheckoutRow extends StatelessWidget {
//   final String label;
//   final String value;
//   final bool isBold;
//   final Icon? icon;
//   final VoidCallback? onTap;
//
//   CheckoutRow({
//     required this.label,
//     required this.value,
//     this.isBold = false,
//     this.icon,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: GestureDetector(
//         onTap: onTap,
//         child: Row(
//           children: [
//             Text(label, style: TextStyle(fontSize: 16)),
//             Spacer(),
//             if (icon != null) icon!,
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             if (onTap != null)
//               Icon(
//                 Icons.chevron_right,
//                 color: Colors.grey,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class CartItem {
//   final String name;
//   final String description;
//   final double price;
//   final String imageUrl;
//   int quantity;
//
//   CartItem(this.name, this.description, this.price, this.imageUrl, {this.quantity = 1});
// }
//
// class CartItemWidget extends StatelessWidget {
//   final CartItem item;
//   final VoidCallback onRemove;
//   final VoidCallback onAdd;
//   final VoidCallback onSubtract;
//
//   CartItemWidget({
//     required this.item,
//     required this.onRemove,
//     required this.onAdd,
//     required this.onSubtract,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Image.asset(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
//           SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(item.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                     IconButton(icon: Icon(Icons.close), onPressed: onRemove),
//                   ],
//                 ),
//                 SizedBox(height: 5),
//                 Text(item.description, style: TextStyle(fontSize: 14, color: Colors.grey)),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: onSubtract,
//                       child: Container(
//                         height: 35,
//                         width: 35,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(13),
//                           border: Border.all(color: Color(0xffE2E2E2)),
//                         ),
//                         child: Center(child: Icon(Icons.remove, color: Color(0xff53B175))),
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     Text(item.quantity.toString(), style: TextStyle(fontSize: 16)),
//                     SizedBox(width: 5),
//                     GestureDetector(
//                       onTap: onAdd,
//                       child: Container(
//                         height: 35,
//                         width: 35,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(13),
//                           border: Border.all(color: Color(0xffE2E2E2)),
//                         ),
//                         child: Center(child: Icon(Icons.add, color: Color(0xff53B175))),
//                       ),
//                     ),
//                     Spacer(),
//                     Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
