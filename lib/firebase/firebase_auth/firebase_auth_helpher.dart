import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food/models/category_model/category_model.dart';
import 'package:food/models/order%20model/order_model.dart';
import 'package:food/models/product_model/product_model.dart';
import 'package:food/models/userModel/user_model.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/routes/route_name.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:food/view/main%20screens/user_home_screen.dart';
import 'package:food/view/user_screens/get_started.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/my_provider.dart';
import '../../utils/constants/constants.dart';
import 'firebase_storage.dart';

class FirebaseAuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorageHelper _firebaseStorageHelper = FirebaseStorageHelper();

  // login page
  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      showDialogBox(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getAuthExceptionMessage(e);
      showErrorDialog(context, errorMessage);
      return false;
    }
  }

  // signUp page
  Future<bool> signUp(String name, String phone, String email, String password,
      Uint8List? myImage, BuildContext context) async {
    try {
      showDialogBox(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String imageUrl = await _firebaseStorageHelper.uploadImage(myImage!);
      print(imageUrl + "hello");
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phone,
        image: imageUrl,
      );
      _firebaseFirestore
          .collection("users")
          .doc(userModel.id)
          .set(userModel.toJson());
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = getAuthExceptionMessage(e);
      showErrorDialog(context, errorMessage);
      return false;
    }
  }

  // get Category Data
  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();
      List<CategoryModel> getCategoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();
      return getCategoriesList;
    } catch (e) {
      MyUtilities.toastMessage(e.toString(), MyColor.errorColor);
      return [];
    }
  }

  // get products
  Future<List<ProductModel>> getProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collectionGroup("products").get();
      List<ProductModel> getProductList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return getProductList;
    } catch (e) {
      MyUtilities.toastMessage(e.toString(), MyColor.errorColor);
      return [];
    }
  }

  // get category product
  Future<List<ProductModel>> getCategoryProduct(String id) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("categories")
              .doc(id)
              .collection("products")
              .get();
      List<ProductModel> getCategoryProductList = querySnapshot.docs
          .map((e) => ProductModel.fromJson(e.data()))
          .toList();
      return getCategoryProductList;
    } catch (e) {
      MyUtilities.toastMessage(e.toString(), MyColor.errorColor);
      return [];
    }
  }

  // get user information
  Future<UserModel> getUserInformation() async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .get();
    return UserModel.fromJson(querySnapshot.data()!);
  }

  // change password
  void changePasswordMethod(
      String oldPassword, String newPassword, BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // create user old credential using email and old password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        // Reauthenticate user with credential
        user.reauthenticateWithCredential(credential);
        // update password
        user.updatePassword(newPassword);
        MyUtilities.toastMessage(
            "Password has been changed", MyColor.primaryColor);
      } on FirebaseAuthException catch (e) {
        if (e.code == "wrong-password") {
          MyUtilities.toastMessage("Invalid old Password", MyColor.errorColor);
        } else {
          MyUtilities.toastMessage(
              "Failed to changed password: $e", MyColor.errorColor);
        }
      } catch (e) {
        MyUtilities.toastMessage(e.toString(), MyColor.errorColor);
      }
    } else {
      MyUtilities.toastMessage(
          "No User is currently signed in", MyColor.errorColor);
    }
  }

  // upload user order in firebase
  Future<bool> uploadUserOrder(BuildContext context,
      List<ProductModel> listModel, String payment) async {
    try {
      double totalPrice = 0.0;
      for (var e in listModel) {
        totalPrice += double.parse(e.price) * e.quantity!;
      }
      DocumentReference documentReference = await _firebaseFirestore
          .collection("userOrders")
          .doc(_auth.currentUser!.uid)
          .collection("orders")
          .doc();
      documentReference.set({
        "product": listModel.map((e) => e.toJson()),
        "totalPrice": totalPrice,
        "payment": payment,
      }).then((value) {
        MyUtilities.toastMessage("Payment Successfully", MyColor.primaryColor);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserHomeScreen()));
      });
      return true;
    } on FirebaseAuthException catch (e) {
      MyUtilities.toastMessage(e.message.toString(), MyColor.primaryColor);
      return false;
    }
  }

  // get user order data
  Future<List<OrderModel>> getUserOrderData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("userOrders")
              .doc(_auth.currentUser!.uid)
              .collection("orders")
              .get();
      return querySnapshot.docs
          .map((e) => OrderModel.fromJson(e.data()))
          .toList();
    } on FirebaseAuthException catch (e) {
      MyUtilities.toastMessage(e.message.toString(), MyColor.errorColor);
      return [];
    }
  }

  // update token
  void updateTokenFromFirebase() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        "Token": token,
      });
    }
  }

  // Function to update the current user data in Firestore
  Future<void> updateUserDataInFirestore(String documentId, String imageUrl,
      String name, String phone, BuildContext context) async {
    final myProvider = Provider.of<MyProvider>(context, listen: false);
    _firebaseFirestore.collection('users').doc(documentId).update({
      'image': imageUrl,
      'name': name.isEmpty ? myProvider.userModel!.name : name,
      'phoneNumber': phone.isEmpty ? myProvider.userModel!.phoneNumber : phone,
    }).then((_) async {
      // print('Image updated successfully in Firestore!');
      await myProvider.getCurrentUserInformation();
      Navigator.pop(context);
      Navigator.of(context, rootNavigator: true).pop();
      MyUtilities.toastMessage(
          'Updated successfully in Firestore!', MyColor.primaryColor);
    }).catchError((error) {
      MyUtilities.toastMessage(error.message.toString(), MyColor.errorColor);
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  // logout method
  static Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirect to the login screen after successful logout
      Navigator.pushReplacementNamed(context, RouteName.loginScreen);
    } catch (e) {
      print('Error during logout: $e');
      // Handle logout error if necessary
    }
  }
}
