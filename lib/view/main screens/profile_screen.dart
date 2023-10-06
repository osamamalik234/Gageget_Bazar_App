import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/utils/routes/route_name.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:food/view/main%20screens/order_screen.dart';
import 'package:food/view/user_screens/edit_screen.dart';
import 'package:food/view/user_screens/favourite_cart_screen.dart';
import 'package:food/view/user_screens/get_started.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import '../user_screens/change_password.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
  @override
  Widget build(BuildContext context) {
    MyProvider myProvider = Provider.of<MyProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          "Profile",
          style: textStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                myProvider.userModel == null
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.black,
                      ))
                    : Expanded(
                        flex: 0,
                        child: Column(
                          children: [
                            myProvider.userModel!.image == null
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyColor.primaryColor,
                                          width: 2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Container(
                                  height: 140,
                                  width: 140,
                                  child: ClipOval(
                                    child: FullScreenWidget(
                                      disposeLevel: DisposeLevel.High,
                                      child: CachedNetworkImage(
                                        imageUrl: myProvider.userModel!.image.toString(),
                                        placeholder: (context, url) => CircularProgressIndicator(
                                          color: MyColor.primaryColor,
                                        ),
                                          fit: BoxFit.cover
                                        // myProvider.userModel!.image
                                        //     .toString(),
                                        // fit: BoxFit.cover,
                                        // frameBuilder: (context,
                                        //     child,
                                        //     frame,
                                        //     wasSynchronouslyLoaded) {
                                        //   return child;
                                        // },
                                        // loadingBuilder: (context, child,
                                        //     loadingProgress) {
                                        //   if (loadingProgress == null) {
                                        //     return child;
                                        //   } else {
                                        //     return Center(
                                        //         child:
                                        //             CircularProgressIndicator(
                                        //       color: MyColor.primaryColor,
                                        //     ));
                                        //   }
                                        // },
                                      ),
                                    ),
                                  ),
                                ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              myProvider.userModel!.name,
                              style: textStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              myProvider.userModel!.email,
                              style: textStyle,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColor.primaryColor,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditScreen()));
                                },
                                child: Center(
                                  child: Text(
                                    "Edit Profile",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderScreen()));
                          },
                          leading: Icon(
                            Icons.shopping_bag_outlined,
                            color: MyColor.primaryColor,
                          ),
                          title: Text("Your Orders", style: textStyle1),
                        ),
                        myDivider,
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavouriteCartItem()));
                          },
                          leading: Icon(
                            Icons.favorite_border,
                            color: MyColor.primaryColor,
                          ),
                          title: Text("Favourite", style: textStyle1),
                        ),
                        myDivider,
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangePasswordScreen()));
                            setState(() {});
                          },
                          leading: Icon(
                            Icons.password,
                            color: MyColor.primaryColor,
                          ),
                          title: Text("Change Password", style: textStyle1),
                        ),
                        myDivider,
                        ListTile(
                          onTap: () {
                            showLogoutPopup(context);
                          },
                          leading: Icon(
                            Icons.logout,
                            color: MyColor.primaryColor,
                          ),
                          title: Text("Log out", style: textStyle1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
