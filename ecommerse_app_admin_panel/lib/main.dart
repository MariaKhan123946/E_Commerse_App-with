
import 'package:ecommerse_app_admin_panel/auth/logging.dart';
import 'package:ecommerse_app_admin_panel/auth/login.dart';
import 'package:ecommerse_app_admin_panel/auth/phonenomberinputscreen.dart';
import 'package:ecommerse_app_admin_panel/auth/selectlocation.dart';
import 'package:ecommerse_app_admin_panel/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/BeveragesScreen.dart';
import 'pages/cart.dart';
import 'pages/explore_page.dart';
import 'pages/filter.dart';
import 'pages/home_page.dart';
import 'pages/Search.dart';
import 'pages/payment card.dart';
import 'pages/trackorder.dart';
import 'welcome_screen/Welcome1.dart';
import 'welcome_screen/orderfaileddialog.dart';
import 'welcome_screen/profile_screen.dart';
import 'welcome_screen/splace_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:SplaceScreen()
    );
  }
}

