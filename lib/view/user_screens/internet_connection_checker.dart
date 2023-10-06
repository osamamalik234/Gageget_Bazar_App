import 'package:flutter/material.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/font_family/my_font_family.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectionCheckerExample extends StatefulWidget {
  const InternetConnectionCheckerExample({Key? key}) : super(key: key);

  @override
  State<InternetConnectionCheckerExample> createState() =>
      _InternetConnectionCheckerExampleState();
}

class _InternetConnectionCheckerExampleState
    extends State<InternetConnectionCheckerExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child:
                  Image.asset("assets/noInternet.jpg", height: 250, width: 250),
            ),
            SizedBox(
              height: 26,
            ),
            Text(
              "Ooops!",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 29,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            const Text(
              "You are not connected to the internet\nPlease check your internet connection",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 18, fontFamily: MyFontFamily.serifFamily),
            ),
            SizedBox(
              height: 42,
            ),
            InkWell(
              onTap: () {
                InternetConnectionChecker().hasConnection.then((connected) {
                  if (connected) {
                    Navigator.pop(context);
                  } else {
                    MyUtilities.toastMessage(
                        "Please check Internet!", MyColor.errorColor);
                  }
                });
              },
              child: Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  color: MyColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Try Again",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
