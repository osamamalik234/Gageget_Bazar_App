import 'package:flutter/material.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/models/category_model/category_model.dart';
import 'package:food/view/user_screens/product_details_screen.dart';

import '../../models/product_model/product_model.dart';
import '../../utils/colors/my_color.dart';
import '../../utils/constants/constants.dart';
import '../../utils/font_family/my_font_family.dart';

class GetCategoryProduct extends StatefulWidget {
  final CategoryModel categoryModel;
  const GetCategoryProduct({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  State<GetCategoryProduct> createState() => _GetCategoryProductState();
}

class _GetCategoryProductState extends State<GetCategoryProduct> {
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  List<ProductModel> getCategoryProduct = [];
  bool isLoading = false;

  @override
  void initState() {
    getProductCategory();
    // TODO: implement initState
    super.initState();
  }

  void getProductCategory() async {
    setState(() {
      isLoading = true;
    });
    getCategoryProduct =
        await _firebaseAuthHelper.getCategoryProduct(widget.categoryModel.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: MyColor.primaryColor,
              ),
            )
          : SafeArea(
              child: getCategoryProduct.isEmpty
                  ? Center(
                      child: Text(
                        "List is Empty",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: MyFontFamily.serifFamily,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              widget.categoryModel.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                fontFamily: MyFontFamily.serifFamily,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: getCategoryProduct.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemBuilder: (context, index) {
                                    ProductModel singleProduct =
                                        getCategoryProduct[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: MyColor.primaryColor, width: 2),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                singleProduct.image,
                                                frameBuilder: (context,
                                                    child,
                                                    frame,
                                                    wasSynchronouslyLoaded) {
                                                  return child;
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  } else {
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: MyColor.primaryColor,
                                                    ));
                                                  }
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  singleProduct.name,
                                                  style: textStyle.copyWith(fontSize: 17),
                                                ),
                                                Text(
                                                  "\$${singleProduct.price.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: MyColor.primaryColor,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsScreen(
                                                                productModel:
                                                                    singleProduct)));
                                              },
                                              child: Center(
                                                child: Text(
                                                  "Buy",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }
}
