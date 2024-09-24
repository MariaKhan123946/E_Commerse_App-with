import 'package:ecommerse_app_admin_panel/auth/selectlocation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VarificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  VarificationScreen({required this.phoneNumber, required this.verificationId});

  @override
  _VarificationScreenState createState() => _VarificationScreenState();
}

class _VarificationScreenState extends State<VarificationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';

  void _onKeyboardTap(String value) {
    setState(() {
      _controller.text += value;
    });
  }

  void _onDelete() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _controller.text =
            _controller.text.substring(0, _controller.text.length - 1);
      });
    }
  }

  // Method to verify the OTP entered by the user
  void _verifyOTP() async {
    String smsCode = _controller.text.trim();

    if (widget.verificationId.isNotEmpty) {
      // Create PhoneAuthCredential with the verification ID and the user-entered OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      // Sign in the user with the credential
      try {
        await _auth.signInWithCredential(credential);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number verified successfully!')),
        );
        // Navigate to LocationSelectScreen after successful OTP verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LocationSelectScreen()),
        );
      } catch (e) {
        print("Failed to verify OTP: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to verify OTP.')),
        );
      }
    } else {
      print("Verification ID is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              'Enter your 6-digit code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Code',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[400]!),
                ),
              ),
              child: Row(
                children: [
                  Image.network(
                    'https://flagcdn.com/w20/pk.png', // Pakistan flag image
                    height: 24,
                    width: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: false, // Disable system keyboard
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FloatingActionButton(
                    onPressed: _verifyOTP, // Verify OTP
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomKeyboard(
                    onKeyboardTap: _onKeyboardTap,
                    onDelete: _onDelete,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CustomKeyboard extends StatelessWidget {
  final Function(String) onKeyboardTap;
  final VoidCallback onDelete;

  CustomKeyboard({required this.onKeyboardTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      child: Column(
        children: [
          // Keypad rows
          _buildKeypadRow(['1', '2', '3']),
          _buildKeypadRow(['4', '5', '6']),
          _buildKeypadRow(['7', '8', '9']),
          _buildKeypadRow(['+', '0', '#']),
          _buildKeypadRow(['*', 'DEL'], deleteButton: true),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> values, {bool deleteButton = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((value) {
        if (deleteButton && value == 'DEL') {
          return _buildDeleteButton();
        } else {
          return _buildKeyboardButton(value);
        }
      }).toList(),
    );
  }

  Widget _buildKeyboardButton(String value) {
    return GestureDetector(
      onTap: () => onKeyboardTap(value),
      child: Container(
        width: 70,
        height: 50,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.backspace_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
