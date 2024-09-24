import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import 'package:intl_phone_field/intl_phone_field.dart';
import 'varification.dart';
// Import the verification screen

class PhoneNumberInputScreen extends StatefulWidget {
  @override
  _PhoneNumberInputScreenState createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _verificationId;
  String _countryCode = '+92'; // Default Bangladesh code

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _onKeyboardTap(String value) {
    setState(() {
      _controller.text += value;
    });
  }

  void _onDelete() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _controller.text = _controller.text.substring(0, _controller.text.length - 1);
      });
    }
  }

  // Method to send OTP using Firebase Authentication
  Future<void> _sendOTP() async {
    final phoneNumber = '$_countryCode${_controller.text}';
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);

      },

      verificationFailed: (FirebaseAuthException e) {
        print('Failed to verify phone number: ${e.message}');

      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number  successfully!')),
        );
        // Navigate to Verification Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VarificationScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'Enter your mobile number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Mobile Number',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),

              // Phone number field with country selector
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'BD', // Initial country
                controller: _controller,  // Use the same controller for IntlPhoneField
                onChanged: (phone) {
                  _countryCode = phone.countryCode; // Update selected country code
                },
              ),

              SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        _sendOTP(); // Send OTP using Firebase
                      },
                      backgroundColor: Colors.green,
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20,),

              // Custom Keyboard
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomKeyboard(
                  onKeyboardTap: _onKeyboardTap,
                  onDelete: _onDelete,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Keyboard Widget
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('1'),
              _buildKeyboardButton('2'),
              _buildKeyboardButton('3'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('4'),
              _buildKeyboardButton('5'),
              _buildKeyboardButton('6'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('7'),
              _buildKeyboardButton('8'),
              _buildKeyboardButton('9'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('+'),
              _buildKeyboardButton('0'),
              _buildKeyboardButton('#'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyboardButton('*'),
              _buildDeleteButton(),
            ],
          ),
        ],
      ),
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
        height: 50,
        width: 50,
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
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
