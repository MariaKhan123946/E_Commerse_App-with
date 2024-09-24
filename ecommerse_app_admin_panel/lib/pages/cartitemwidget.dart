import 'package:ecommerse_app_admin_panel/pages/cartitem.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  CartItemWidget({
    required this.item,
    required this.onRemove,
    required this.onAdd,
    required this.onSubtract,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Image.network(
            item.image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(item.description, style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 10),
                Text('\$${item.price}', style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onAdd,
                icon: Icon(Icons.add, color: Colors.green),
              ),
              Text('${item.quantity}'),
              IconButton(
                onPressed: onSubtract,
                icon: Icon(Icons.remove, color: Colors.red),
              ),
            ],
          ),
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
