import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/component/app_button.dart';
import 'package:food/component/text_field.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/images/my_images.dart';
import 'package:food/utils/routes/route_name.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import '../../utils/constants/constants.dart';
import '../../utils/internet_connection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

  // making an object of internet connection
  CheckInternetConnection checkInternetConnection = CheckInternetConnection();
  @override
  void initState() {
    checkInternetConnection.checkConnectivity(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _obscureText = false;
    FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                MyImages.loginImage,
                height: 230,
                width: 230,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Please Enter your credentials\tto login!",
                textAlign: TextAlign.center,
                style: textStyle,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormFieldComponent(
                controller: _emailController,
                focusNode: emailNode,
                onFieldSubmittedValue: (value) {
                  MyUtilities.focusField(context, emailNode, passNode);
                },
                onValidator: (value) {
                  return value.isEmpty ? "Enter Email" : null;
                },
                keyBoardType: TextInputType.emailAddress,
                hint: "Email",
                prefixIcon: Icons.email,
                obsecureText: _obscureText,
              ),
              const SizedBox(
                height: 20,
              ),
              StatefulBuilder(builder: (context, internalState) {
                return TextFormFieldComponent(
                  controller: _passController,
                  focusNode: passNode,
                  onFieldSubmittedValue: (value) {
                    MyUtilities.focusField(context, passNode, emailNode);
                  },
                  onValidator: (value) {
                    return value.isEmpty ? "Enter Password" : null;
                  },
                  keyBoardType: TextInputType.emailAddress,
                  hint: "Password",
                  obsecureText: _obscureText,
                  prefixIcon: Icons.lock,
                  suffixIcon:
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                  onIconPress: () {
                    internalState(() {
                      print(_obscureText);
                      _obscureText = !_obscureText;
                    });
                  },
                );
              }),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.forgetPasswordScreen);
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                      color: MyColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              AppButton(
                text: "Login",
                onPress: () async {
                  bool isValidate = validateLogin(
                      _emailController.text, _passController.text);
                  if (isValidate) {
                    bool isLogin = await firebaseAuthHelper.login(
                        _emailController.text, _passController.text, context);
                    if (isLogin) {
                      Navigator.pushNamed(
                          context, RouteName.customNavigationBar);
                    }
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please create an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  CupertinoTextButton(
                    text: "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                    color: MyColor.primaryColor,
                    pressedColor: MyColor.primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.signUpScreen);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
