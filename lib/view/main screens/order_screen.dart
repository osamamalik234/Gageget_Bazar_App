import 'package:flutter/material.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/models/order%20model/order_model.dart';
import 'package:food/provider/my_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/colors/my_color.dart';
import '../../utils/constants/constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper();
  List<OrderModel> getOrderData = [];

  @override
  void initState() {
    getUserOrder();
    // TODO: implement initState
    super.initState();
  }

  void getUserOrder() async {
    getOrderData = await firebaseAuthHelper.getUserOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Your Order",
          style: textStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: Stream.fromFuture(firebaseAuthHelper.getUserOrderData()),
          builder:
              (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: MyColor.primaryColor,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No Order"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: ExpansionTile(
                        collapsedShape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: MyColor.primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: MyColor.primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textColor: Colors.black,
                        iconColor: MyColor.primaryColor,
                        title: Row(
                          children: [
                            Image.network(orderModel.product[0].image,
                                height: 100, width: 100),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ReusableRow(
                                    text: "Name:  ",
                                    text2: orderModel.product[0].name),
                                SizedBox(
                                  height: 5,
                                ),
                                orderModel.product.length > 1
                                    ? SizedBox.fromSize()
                                    : ReusableRow(
                                        text: "Quantity:  ",
                                        text2: orderModel.product[0].quantity
                                            .toString()),
                                SizedBox(
                                  height: 5,
                                ),
                                orderModel.product.length > 1
                                    ? SizedBox.fromSize()
                                    : ReusableRow(
                                        text: "Price:  ",
                                        text2: orderModel.product[0].price),
                                SizedBox(
                                  height: 5,
                                ),
                                ReusableRow(
                                  text: "Total Price:  ",
                                  text2: orderModel.totalPrice.toString(),
                                )
                              ],
                            ),
                          ],
                        ),
                        children: orderModel.product.length > 1
                            ? [
                                Text(
                                  "Details",
                                  style: textStyle,
                                ),
                                Divider(
                                  indent: 10,
                                  endIndent: 10,
                                  color: MyColor.primaryColor,
                                ),
                                ...orderModel.product.map((e) {
                                  return Row(
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                          e.image,
                                        ),
                                        height: 100,
                                        width: 100,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ReusableRow(
                                              text: "Name:  ", text2: e.name),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ReusableRow(
                                              text: "Quantity:  ",
                                              text2: e.quantity.toString()),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ReusableRow(
                                            text: "Price:  ",
                                            text2: e.price.toString(),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                }).toList()
                              ]
                            : [],
                      ),
                    );
                  });
            }
            return Center(
              child: Text(
                "No order found!",
                style: textStyle,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String text;
  final String text2;
  const ReusableRow({Key? key, required this.text, required this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: textStyle.copyWith(fontSize: 14),
        ),
        Text(
          text2,
          style: textStyle.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
