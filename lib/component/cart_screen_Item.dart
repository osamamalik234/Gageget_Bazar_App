import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:flutter/material.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:provider/provider.dart';

import '../models/product_model/product_model.dart';
import '../utils/colors/my_color.dart';

class CartScreenItemContainer extends StatefulWidget {
  final ProductModel productModel;
  const CartScreenItemContainer({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<CartScreenItemContainer> createState() =>
      _CartScreenItemContainerState();
}

class _CartScreenItemContainerState extends State<CartScreenItemContainer> {
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
    return Container(
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
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image(image: NetworkImage(widget.productModel.image)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 20),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.productModel.name,
                            style: textStyle.copyWith(fontSize: 17),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: MyColor.primaryColor,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (quantity > 1) {
                                            quantity--;
                                          }
                                        });
                                        myProvider.updateProductQuantity(
                                            widget.productModel, quantity);
                                      },
                                      icon: Icon(
                                        Icons.remove_outlined,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "$quantity",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: MyColor.primaryColor,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                      });
                                      myProvider.updateProductQuantity(
                                          widget.productModel, quantity);
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CupertinoTextButton(
                                text: myProvider.getFavouriteCartList
                                        .contains(widget.productModel)
                                    ? "Removed to WishList"
                                    : "Add to WishList",
                                style: TextStyle(
                                  // color: MyColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.primaryColor,
                                ),
                                color: MyColor.primaryColor,
                                pressedColor: MyColor.primaryColor,
                                onTap: () {
                                  if (!myProvider.getFavouriteCartList
                                      .contains(widget.productModel)) {
                                    myProvider.addFavouriteCartItem(
                                        widget.productModel);
                                    MyUtilities.toastMessage(
                                        "Added to WishList",
                                        MyColor.primaryColor);
                                  } else {
                                    myProvider.removeFavouriteCartItem(
                                        widget.productModel);
                                    MyUtilities.toastMessage(
                                        "Removed from WhisList",
                                        MyColor.errorColor);
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        "\$${widget.productModel.price}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        final myProvider =
                            Provider.of<MyProvider>(context, listen: false);
                        myProvider.removeCart(widget.productModel);
                        MyUtilities.toastMessage(
                            "Removed from Cart List", MyColor.errorColor);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
