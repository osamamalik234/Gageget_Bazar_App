import 'package:flutter/material.dart';
import 'package:food/component/app_button.dart';
import 'package:food/utils/images/my_images.dart';

import '../auth_screen/login_singUp_screen.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Image.asset(MyImages.shopImage1)),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "The Fastest In Delivery Equipments",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Serif'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Efficiently manage and maintain equipment inventory with our user-friendly mobile app for businesses and individuals.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Serif'),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  AppButton(
                    text: "Get Started ->",
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginSignUpScreen()));
                    },
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
