import 'package:flutter/material.dart';
import 'package:food/models/product_model/product_model.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/utils/font_family/my_font_family.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:food/view/user_screens/check_out_screen.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: textStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: leadingIcon(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 310,
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyColor.primaryColor,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(
                    widget.productModel.image,
                  ),
                  scale: 0.5,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.productModel.name,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.productModel.isFavourite =
                            !widget.productModel.isFavourite;
                      });
                      if (widget.productModel.isFavourite) {
                        myProvider.addFavouriteCartItem(widget.productModel);
                        MyUtilities.toastMessage(
                            "Added to Favorite", MyColor.primaryColor);
                      } else {
                        myProvider.removeFavouriteCartItem(widget.productModel);
                        MyUtilities.toastMessage(
                            "Removed From Favourite", MyColor.primaryColor);
                      }
                    },
                    icon: Icon(myProvider.getFavouriteCartList
                            .contains(widget.productModel)
                        ? Icons.favorite
                        : Icons.favorite_border)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.productModel.discription,
              textAlign: TextAlign.justify,
              style:
                  TextStyle(fontSize: 15, fontFamily: MyFontFamily.serifFamily),
            ),
            SizedBox(
              height: 20,
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: MyColor.primaryColor),
                    ),
                    onPressed: () {
                      final myProvider =
                          Provider.of<MyProvider>(context, listen: false);
                      ProductModel singleProduct =
                          widget.productModel.copyWith(quantity: quantity);
                      myProvider.addCart(singleProduct);
                      MyUtilities.toastMessage(
                          "Added to Cart", MyColor.primaryColor);
                    },
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 17, color: MyColor.primaryColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.primaryColor,
                      ),
                      onPressed: () {
                      ProductModel productModel =   widget.productModel.copyWith(quantity: quantity);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckOutScreen(productModel: productModel,)));
                      },
                      child: Center(
                        child: Text(
                          "Buy",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget leadingIcon(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 15),
    child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 25,
        )),
  );
}
