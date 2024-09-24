import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'phonenomberinputscreen.dart'; // import the new screen

class NectarLoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Phone Number Authentication
  void _signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _navigateToPhoneNumberInputScreen(context); // Navigate after successful phone sign-in
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Phone verification failed: ${e.message}"),
        ));
      },
      codeSent: (String verificationId, int? resendToken) async {
        String smsCode = await _showOtpDialog(context);
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        await _auth.signInWithCredential(credential);
        _navigateToPhoneNumberInputScreen(context); // Navigate after successful OTP input
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Google Sign-In
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
        _navigateToPhoneNumberInputScreen(context); // Navigate after Google sign-in
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Google sign-in failed: $e"),
      ));
    }
  }

  // Show OTP Dialog
  Future<String> _showOtpDialog(BuildContext context) async {
    String otp = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter OTP"),
          content: TextField(
            onChanged: (value) {
              otp = value;
            },
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
    return otp;
  }

  // Navigate to PhoneNumberInputScreen
  void _navigateToPhoneNumberInputScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneNumberInputScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/img_3.png',
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Get your groceries\nwith nectar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          'https://flagcdn.com/w20/bd.png',
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '+880',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              _signInWithPhoneNumber(context, '+880$value');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Or connect with social media',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
              ],
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _signInWithGoogle(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4285F4),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.g_mobiledata, color: Colors.white),
                      label: Text(
                        'Continue with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {}, // You can add Facebook login logic here
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3b5998),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(Icons.facebook, color: Colors.white),
                      label: Text(
                        'Continue with Facebook',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
