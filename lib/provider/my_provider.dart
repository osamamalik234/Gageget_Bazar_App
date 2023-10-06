import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import '../firebase/firebase_auth/firebase_storage.dart';
import '../models/order model/order_model.dart';
import '../models/product_model/product_model.dart';
import '../models/userModel/user_model.dart';
import '../utils/constants/constants.dart';

class MyProvider with ChangeNotifier {
  // add cart work only
  List<ProductModel> _getCartList = [];
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  FirebaseStorageHelper _firebaseStorageHelper = FirebaseStorageHelper();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserModel? _userModel;

  List<OrderModel> _getCurrentUserOrderData = [];
  // Add cart into cart Screen
  void addCart(ProductModel productModel) {
    _getCartList.add(productModel);
    notifyListeners();
  }

  // remove cart from cart Screen
  void removeCart(ProductModel productModel) {
    _getCartList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getCartList {
    return _getCartList;
  }

  // Favourite Cart work

  List<ProductModel> _getFavouriteCartList = [];

  void addFavouriteCartItem(ProductModel productModel) {
    _getFavouriteCartList.add(productModel);
    notifyListeners();
  }

  void removeFavouriteCartItem(ProductModel productModel) {
    _getFavouriteCartList.remove(productModel);
    notifyListeners();
  }

  List<ProductModel> get getFavouriteCartList => _getFavouriteCartList;

  // set user data
  Future<void> getCurrentUserInformation() async {
    _userModel = await _firebaseAuthHelper.getUserInformation();
    notifyListeners();
  }
  // get user data
  UserModel? get userModel => _userModel;

   totalPrice(){
    var tPrice = 0.0;
    for(var e in _getCartList){
     tPrice += double.parse(e.price) * e.quantity!;
    }
    return tPrice;
  }

  // update product quantity
  void updateProductQuantity(ProductModel productModel , int qty) {
    int index = _getCartList.indexOf(productModel);
    _getCartList[index].quantity = qty;
    notifyListeners();
  }
  // buy product
  List<ProductModel> _getBuyProducts = [];
  List<ProductModel> get getBuyProducts => _getBuyProducts;

  void getUserBuyProduct(ProductModel productModel) {
    _getBuyProducts.add(productModel);
    notifyListeners();
  }

  // add cart list data into buy product list

  void addBuyProductListCart(){
    _getBuyProducts.addAll(_getCartList);
    notifyListeners();
  }

  // clear list of cart screen
  void clearCartProduct(){
    _getCartList.clear();
    notifyListeners();
  }
  // clear list of buy products
  void clearBuyProducts(){
    _getBuyProducts.clear();
    notifyListeners();
  }

  List<OrderModel> get getCurrentUserOrderData => _getCurrentUserOrderData;

  void setOrderData() async {
    _getCurrentUserOrderData  = await _firebaseAuthHelper.getUserOrderData();
    notifyListeners();
  }
}

