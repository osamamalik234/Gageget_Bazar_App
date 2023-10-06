import 'package:flutter/material.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/view/user_screens/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../../component/favourite_cart_component.dart';
import '../../utils/font_family/my_font_family.dart';

class FavouriteCartItem extends StatefulWidget {
  const FavouriteCartItem({Key? key}) : super(key: key);

  @override
  State<FavouriteCartItem> createState() => _FavouriteCartItemState();
}

class _FavouriteCartItemState extends State<FavouriteCartItem> {
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            "Favourite Screen",
            style: textStyle,
          ),
          centerTitle: true,
          leading: leadingIcon(context),
        ),
        body: myProvider.getFavouriteCartList.isEmpty
            ? Center(
                child: Text(
                  "Favourite List is Empty",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                      itemCount: myProvider.getFavouriteCartList.length,
                      itemBuilder: (context, index) {
                        return FavouriteCartComponent(
                          productModel: myProvider.getFavouriteCartList[index],
                        );
                      }),
                ),
              ));
  }
}
