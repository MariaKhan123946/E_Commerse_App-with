import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerse_app_admin_panel/color/appcolor.dart';
import 'package:ecommerse_app_admin_panel/pages/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MySample());
}

class MySample extends StatefulWidget {
  const MySample({super.key});

  @override
  State<StatefulWidget> createState() => MySampleState();
}

class MySampleState extends State<MySample> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.white,
          background: Colors.black,
          primary: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          titleMedium: TextStyle(color: Colors.white, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.black,
          background: Colors.white,
          primary: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage(
                    isLightTheme ? 'assets/bg-light.png' : 'assets/bg-dark.png',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => setState(() {
                        isLightTheme = !isLightTheme;
                      }),
                      icon: Icon(
                        isLightTheme ? Icons.light_mode : Icons.dark_mode,
                      ),
                    ),
                    CreditCardWidget(
                      enableFloatingCard: useFloatingAnimation,
                      glassmorphismConfig: _getGlassmorphismConfig(),
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      bankName: 'Axis Bank',
                      frontCardBorder: useGlassMorphism
                          ? null
                          : Border.all(color: Colors.grey),
                      backCardBorder: useGlassMorphism
                          ? null
                          : Border.all(color: Colors.grey),
                      showBackView: isCvvFocused,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      cardBgColor: isLightTheme
                          ? AppColors.cardBgLightColor
                          : AppColors.cardBgColor,
                      backgroundImage:
                      useBackgroundImage ? 'assets/card_bg.png' : null,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            'assets/mastercard.png',
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              inputConfiguration: const InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Number',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  labelText: 'Card Holder',
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            const SizedBox(height: 20),
                            _buildSwitch(
                              'Glassmorphism',
                              useGlassMorphism,
                                  (value) {
                                setState(() {
                                  useGlassMorphism = value;
                                });
                              },
                            ),
                            _buildSwitch(
                              'Card Image',
                              useBackgroundImage,
                                  (value) {
                                setState(() {
                                  useBackgroundImage = value;
                                });
                              },
                            ),
                            _buildSwitch(
                              'Floating Card',
                              useFloatingAnimation,
                                  (value) {
                                setState(() {
                                  useFloatingAnimation = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _onValidate,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      AppColors.colorB58D67,
                                      AppColors.colorB58D67,
                                      AppColors.colorE5D1B2,
                                      AppColors.colorF9EED2,
                                      AppColors.colorEFEFED,
                                      AppColors.colorF9EED2,
                                      AppColors.colorB58D67,
                                    ],
                                    begin: Alignment(-1, -4),
                                    end: Alignment(1, 4),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Validate',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'halter',
                                    fontSize: 14,
                                    package: 'flutter_credit_card',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSwitch(
      String text, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text),
          const Spacer(),
          Switch(
            value: value,
            inactiveTrackColor: Colors.grey,
            activeColor: Colors.white,
            activeTrackColor: AppColors.colorE5D1B2,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _onValidate() async {
    if (formKey.currentState?.validate() ?? false) {
      print('Valid!');
      // Save the payment details to Firestore
      await FirebaseFirestore.instance.collection('payments').add({
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        'card_holder_name': cardHolderName,
        'cvv_code': cvvCode,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        print('Payment added to Firestore successfully!');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment saved successfully!',style: TextStyle(color: Colors.green),)),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartScreen())
        );
      }).catchError((error) {
        print('Failed to save payment: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    } else {
      print('Invalid!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid card details')),
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel?.cardNumber ?? '';
      expiryDate = creditCardModel?.expiryDate ?? '';
      cardHolderName = creditCardModel?.cardHolderName ?? '';
      cvvCode = creditCardModel?.cvvCode ?? '';
      isCvvFocused = creditCardModel?.isCvvFocused ?? false;
    });
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }
    return Glassmorphism(
      blurX: 10.0,
      blurY: 10.0,
      gradient: LinearGradient(
        colors: <Color>[
          Colors.grey.withAlpha(20),
          Colors.white.withAlpha(20),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const <double>[
          0.3,
          0,
        ],
      ),
    );
  }
}
