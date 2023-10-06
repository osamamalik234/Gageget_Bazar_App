import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/font_family/my_font_family.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// here Dialog box will be shown during validation
showDialogBox(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(builder: (context) {
      return SizedBox(
        height: 100,
        child: Column(
          children: [
            SpinKitSpinningLines(
              color: MyColor.primaryColor,
              size: 50.0,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Loading....",
              style:
                  TextStyle(fontSize: 18, fontFamily: MyFontFamily.serifFamily),
            )
          ],
        ),
      );
    }),
  );

  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alert;
      });
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
// login validation
bool validateLogin(String email, String password) {
  if (email.isEmpty && password.isEmpty) {
    MyUtilities.toastMessage("Please Enter All details", MyColor.errorColor);
    return false;
  } else if (email.isEmpty) {
    MyUtilities.toastMessage("Please Enter Email", MyColor.errorColor);
    return false;
  } else if (!regExp.hasMatch(email)) {
    MyUtilities.toastMessage("Email is not valid", MyColor.errorColor);
    return false;
  } else if (password.isEmpty) {
    MyUtilities.toastMessage("Please Enter Password", MyColor.errorColor);
    return false;
  } else if (password.length < 6) {
    MyUtilities.toastMessage(
        "Password should be atleast 6 characters", MyColor.errorColor);
    return false;
  } else {
    return true;
  }
}

// signUp validation

bool signUpValidation(String name, String phone, String email, String password,
    Uint8List? image) {
  if (name.isEmpty && phone.isEmpty && email.isEmpty && password.isEmpty) {
    MyUtilities.toastMessage("Please Enter All details", MyColor.errorColor);
    return false;
  } else if (name.isEmpty) {
    MyUtilities.toastMessage("Please Enter Name", MyColor.errorColor);
    return false;
  } else if (phone.isEmpty) {
    MyUtilities.toastMessage("Please Enter Phone", MyColor.errorColor);
    return false;
  } else if (phone.length < 11) {
    MyUtilities.toastMessage(
        "Phone Number must be 11 digits!", MyColor.errorColor);
    return false;
  } else if (email.isEmpty) {
    MyUtilities.toastMessage("Please Enter Email", MyColor.errorColor);
    return false;
  } else if (!regExp.hasMatch(email)) {
    MyUtilities.toastMessage("Email is not valid", MyColor.errorColor);
    return false;
  } else if (password.isEmpty) {
    MyUtilities.toastMessage("Please Enter Password", MyColor.errorColor);
    return false;
  } else if (password.length < 6) {
    MyUtilities.toastMessage(
        "Password should be atleast 6 characters", MyColor.errorColor);
    return false;
  } else if (image == null) {
    MyUtilities.toastMessage("Please select your image", MyColor.errorColor);
    return false;
  } else {
    return true;
  }
}

bool validateUpdatePassword(
    String oldPassword, String newPass, String confirmPassword) {
  if (oldPassword.isEmpty && newPass.isEmpty && confirmPassword.isEmpty) {
    MyUtilities.toastMessage("Please fill all the fields", MyColor.errorColor);
    return false;
  } else if (oldPassword.isEmpty) {
    MyUtilities.toastMessage("Please Enter Old password", MyColor.errorColor);
    return false;
  } else if (newPass.isEmpty) {
    MyUtilities.toastMessage("Please Enter new password", MyColor.errorColor);
    return false;
  } else if (confirmPassword.isEmpty) {
    MyUtilities.toastMessage(
        "Please Enter confirm password", MyColor.errorColor);
    return false;
  } else {
    return true;
  }
}

// styling to text
TextStyle textStyle = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontFamily: MyFontFamily.serifFamily,
  fontWeight: FontWeight.bold,
);
// styling to text 1
TextStyle textStyle1 =
    TextStyle(fontSize: 18, fontFamily: MyFontFamily.serifFamily);

// Divider

Divider myDivider = Divider(
  thickness: 3,
  indent: 20,
  endIndent: 20,
);

// logout dialog box
showLogoutPopup(context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Do you want to logout?"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          FirebaseAuthHelper.logout(context).then((value) {
                            MyUtilities.toastMessage(
                                "User Logged out", MyColor.primaryColor);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.primaryColor),
                        child: const Text("Yes"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text("No",
                          style: TextStyle(color: Colors.black)),
                    ))
                  ],
                )
              ],
            ),
          ),
        );
      });
}

String getAuthExceptionMessage(FirebaseAuthException exception) {
  switch (exception.code) {
    case 'user-not-found':
      return 'User not found. Please check your email and try again.';
    case 'wrong-password':
      return 'Invalid password. Please try again.';
    case 'invalid-email':
      return 'Invalid email address. Please enter a valid email.';
    case 'too-many-requests':
      return 'Too many sign-in attempts. Please try again later.';
    case 'email-already-in-use':
      return 'Email address is already registered. Please use a different email.';
    case 'weak-password':
      return 'Password is too weak. Please use a stronger password.';
    case 'operation-not-allowed':
      return 'The requested operation is not allowed.';
    case 'user-disabled':
      return 'User account has been disabled. Please contact support for assistance.';
    // Add more cases to handle other Firebase Auth exceptions as needed
    default:
      return 'An error occurred: ${exception.message}';
  }
}

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              'OK',
              selectionColor: MyColor.primaryColor,
            ),
          ),
        ],
      );
    },
  );
}
