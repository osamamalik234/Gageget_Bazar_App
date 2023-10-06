import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:flutter/material.dart';
import 'package:food/models/product_model/product_model.dart';
import 'package:provider/provider.dart';

import '../provider/my_provider.dart';
import '../utils/colors/my_color.dart';
import '../utils/validation_utils/my_utilities.dart';

class FavouriteCartComponent extends StatefulWidget {
  final ProductModel productModel;
  const FavouriteCartComponent({Key? key, required this.productModel}) : super(key: key);

  @override
  State<FavouriteCartComponent> createState() => _FavouriteCartComponentState();
}

class _FavouriteCartComponentState extends State<FavouriteCartComponent> {
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MyColor.primaryColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: MyColor.primaryColor,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: Image(image: NetworkImage(widget.productModel.image)),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, right: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          widget.productModel.name,
                          style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15,),
                        CupertinoTextButton(
                          text: "Remove to WishList",
                          style: TextStyle(
                            // color: MyColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          color: MyColor.primaryColor,
                          pressedColor: MyColor.primaryColor,
                          onTap: () {
                            myProvider.removeFavouriteCartItem(widget.productModel);
                            MyUtilities.toastMessage("Removed From Favourite", MyColor.primaryColor);
                          },
                        )
                      ],
                    ),
                    Text(
                      "\$${widget.productModel.price}",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
