import 'package:flutter/material.dart';

class CheckoutRow extends StatelessWidget {
  final String label;
  final String value;
  final Icon? icon;
  final bool isBold;
  final VoidCallback? onTap;

  CheckoutRow({
    required this.label,
    required this.value,
    this.icon,
    this.isBold = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Row(
              children: [
                if (icon != null) icon!,
                SizedBox(width: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                    color: isBold ? Colors.black : Colors.grey,
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
