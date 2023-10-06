import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/AdMobe%20Services/ad_mob_service.dart';
import 'package:food/component/text_field.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/view/user_screens/product_details_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../Firebase Notifications/notification_services.dart';
import '../../models/category_model/category_model.dart';
import '../../models/product_model/product_model.dart';
import '../../provider/my_provider.dart';
import '../../utils/font_family/my_font_family.dart';
import '../../utils/internet_connection.dart';
import '../user_screens/get_category_product.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _searchController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  List<CategoryModel> getCategoriesList = [];
  List<ProductModel> getProductList = [];
  bool isLoading = false;

  // to show Ads
  BannerAd? _banner;
  InterstitialAd? _interstitialAd;

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobServices.getInterstitialAdUnitId()!,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  FirebaseNotificationServices firebaseNotificationServices =
      FirebaseNotificationServices();
  @override
  void initState() {
    getCategories();
    MyProvider myProvider = Provider.of<MyProvider>(context, listen: false);
    myProvider.getCurrentUserInformation();
    // _firebaseAuthHelper.getUserOrderData();
    firebaseNotificationServices.getDeviceToken().then((value) {
      print("Device Token");
      print(value);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _banner = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobServices.getBannerAdUnitId()!,
      listener: AdMobServices.bannerAdListener,
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  // get Categories
  void getCategories() async {
    setState(() {
      isLoading = true;
    });
    _firebaseAuthHelper.updateTokenFromFirebase();
    getCategoriesList = await _firebaseAuthHelper.getCategories();
    getProductList = await _firebaseAuthHelper.getProducts();

    setState(() {
      isLoading = false;
    });
  }

  List<ProductModel> searchList = [];
  void searchProducts(String value) {
    searchList = getProductList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
    print(searchList.length);
  }

  // get ProductList
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    bool _obsecureText = false;
    return Scaffold(
      bottomNavigationBar: _banner == null
          ? Container(
              child: Text("No Ad Found"),
            )
          : Container(
              height: 50,
              child: AdWidget(ad: _banner!),
            ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: MyColor.primaryColor,
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "E-Commerce",
                              style: textStyle,
                            ),
                            ClipOval(
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                    color: MyColor.primaryColor,
                                  ),
                                ),
                                imageUrl:
                                    myProvider.userModel!.image.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormFieldComponent(
                          controller: _searchController,
                          onFieldSubmittedValue: (value) {},
                          onValidator: (value) {
                            return null;
                          },
                          focusNode: _textFieldFocusNode,
                          onChanged: (String value) {
                            searchProducts(value);
                          },
                          keyBoardType: TextInputType.name,
                          hint: "Search",
                          obsecureText: _obsecureText,
                          prefixIcon: Icons.search),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Categories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: MyFontFamily.serifFamily,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                            children: getCategoriesList
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GetCategoryProduct(
                                                    categoryModel: e,
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                e.image,
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
                                                      color:
                                                          MyColor.primaryColor,
                                                    ));
                                                  }
                                                },
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Top Selling",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: MyFontFamily.serifFamily,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      _searchController.text.isNotEmpty && searchList.isEmpty
                          ? Center(
                              child: Text("No Data Found"),
                            )
                          : searchList.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: searchList.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.7,
                                      ),
                                      itemBuilder: (context, index) {
                                        ProductModel singleProduct =
                                            searchList[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                            // color: MyColor.containerColor,
                                            border: Border.all(
                                                color: MyColor.primaryColor,
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      } else {
                                                        return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: MyColor
                                                              .primaryColor,
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      singleProduct.name,
                                                      style: TextStyle(
                                                          fontSize: 18),
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
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        MyColor.primaryColor,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsScreen(
                                                                productModel:
                                                                    singleProduct),
                                                      ),
                                                    );
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
                                )
                              : getProductList.isEmpty
                                  ? Center(
                                      child: Text("List is Empty"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: getProductList.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 0.7,
                                          ),
                                          itemBuilder: (context, index) {
                                            ProductModel singleProduct =
                                                getProductList[index];
                                            return Container(
                                              decoration: BoxDecoration(
                                                // color: MyColor.containerColor,
                                                border: Border.all(
                                                    color: MyColor.primaryColor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          } else {
                                                            return Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                              color: MyColor
                                                                  .primaryColor,
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
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                          singleProduct.name,
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          "\$${singleProduct.price.toString()}",
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    OutlinedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        backgroundColor: MyColor
                                                            .primaryColor,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProductDetailsScreen(
                                                                    productModel:
                                                                        singleProduct),
                                                          ),
                                                        );
                                                      },
                                                      child: Center(
                                                        child: Text(
                                                          "Buy",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
