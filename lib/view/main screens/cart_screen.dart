import 'package:flutter/material.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/view/user_screens/check_out_screen.dart';
import 'package:provider/provider.dart';
import '../../component/app_button.dart';
import '../../component/cart_screen_Item.dart';
import '../../provider/my_provider.dart';
import '../user_screens/cart_item_checkout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            height: 150,
            child: Column(
              children: [
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Price:" ,style: textStyle,),
                    Text("\$${myProvider.totalPrice()}", style: textStyle,),
                  ],
                ),
                SizedBox(height: 25,),
                AppButton(text: "Checkout", onPress: (){
                   myProvider.clearBuyProducts();
                   myProvider.addBuyProductListCart();
                   Navigator.push(context, MaterialPageRoute(builder: (context) => CartItemCheckoutScreen()));
                }),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Cart Screen",
            style: textStyle,
          ),
          centerTitle: true,
        ),
        body: myProvider.getCartList.isEmpty
            ? Center(
                child: Text(
                  "No Item",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                      itemCount: myProvider.getCartList.length,
                      itemBuilder: (context, index) {
                        return CartScreenItemContainer(
                          productModel: myProvider.getCartList[index],
                        );
                      }),
                ),
              ));
  }
}
