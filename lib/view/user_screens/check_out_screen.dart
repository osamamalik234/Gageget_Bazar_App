

import 'package:flutter/material.dart';
import 'package:food/component/app_button.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/models/order%20model/order_model.dart';
import 'package:food/models/product_model/product_model.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/stripe%20payment/stripe_paymen.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/view/user_screens/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../stripe payment/stripe_payment2.dart';
import '../../utils/constants/constants.dart';

class CheckOutScreen extends StatefulWidget {
  final ProductModel productModel;
  const CheckOutScreen({Key? key, required this.productModel, })
      : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  int groupValue = 1;
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  StripePayment2 _stripePayment = StripePayment2();

  int quantity = 1;
  @override
  void initState() {
    quantity = widget.productModel.quantity ?? 0;
    setState(() {});
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
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 30),
      //   child: Container(
      //     height: 150,
      //     child: Column(
      //       children: [
      //         SizedBox(height: 30,),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text("Total Price:" ,style: textStyle,),
      //             Text("\$${myProvider.totalPrice()}", style: textStyle,),
      //           ],
      //         ),
      //         SizedBox(height: 25,),
      //       ],
      //     ),
      //   ),
      // ),
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
                    if (groupValue == 1) {
                      myProvider.clearBuyProducts();
                      myProvider.getUserBuyProduct(widget.productModel);
                      _firebaseAuthHelper.uploadUserOrder(context,
                          myProvider.getBuyProducts, "Cash on Delivery");
                    } else {
                      myProvider.clearBuyProducts();
                      int value =
                          double.parse(widget.productModel.price).toInt() * quantity;
                      String totalPri = (value * 100).toString();
                      _stripePayment.makePayment(
                          totalPri, context, widget.productModel);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
