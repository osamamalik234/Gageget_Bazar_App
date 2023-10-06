import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food/component/app_button.dart';
import 'package:food/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/models/product_model/product_model.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:food/view/user_screens/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../stripe payment/stripe_paymen.dart';
import '../../utils/constants/constants.dart';
import '../../utils/internet_connection.dart';

class CartItemCheckoutScreen extends StatefulWidget {
  const CartItemCheckoutScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartItemCheckoutScreen> createState() => _CartItemCheckoutScreenState();
}

class _CartItemCheckoutScreenState extends State<CartItemCheckoutScreen> {
  int groupValue = 1;
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  StripePayment _stripePayment = StripePayment();

  CheckInternetConnection checkInternetConnection = CheckInternetConnection();
  @override
  void initState() {
    checkInternetConnection.checkConnectivity(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: textStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: leadingIcon(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColor.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Radio(
                        value: 1,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.money),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Case on Delivery",
                      style: textStyle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColor.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Radio(
                        value: 2,
                        groupValue: groupValue,
                        onChanged: (value) {
                          setState(() {
                            groupValue = value!;
                          });
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.money),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Pay Online",
                      style: textStyle.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              AppButton(
                  text: "Continue",
                  onPress: () async {
                    if (myProvider.getCartList.isNotEmpty) {
                      if (groupValue == 1) {
                        _firebaseAuthHelper.uploadUserOrder(context,
                            myProvider.getBuyProducts, "Cash on Delivery");
                        myProvider.clearCartProduct();
                      } else {
                        int value =
                            double.parse(myProvider.totalPrice().toString())
                                .round()
                                .toInt();
                        String totalPrice = (value * 100).toString();
                        _stripePayment.makePayment(
                            totalPrice.toString(), context);
                      }
                    } else {
                      MyUtilities.toastMessage(
                          "There is no item in Cart", MyColor.errorColor);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
