import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/provider/my_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class StripePayment {

  Map<String, dynamic>? paymentIntent;
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  Future<void> makePayment(String amount, BuildContext context) async {
    try {
      print(amount);
      paymentIntent = await createPaymentIntent(amount, 'USD');

      var gpay = PaymentSheetGooglePay(
          merchantCountryCode: "US", currencyCode: "USD", testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Osama Malik',
                  googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(context);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet(BuildContext context) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        _firebaseAuthHelper.uploadUserOrder(context,
                  myProvider.getBuyProducts, "Paid online");
              myProvider.clearCartProduct();
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51MWx8OAVMyklfe3C3gP4wKOhTsRdF6r1PYhhg1PqupXDITMrV3asj5Mmf0G5F9moPL6zNfG3juK8KHgV9XNzFPlq00wmjWwZYA',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
