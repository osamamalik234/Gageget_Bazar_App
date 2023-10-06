import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyUtilities {

  // focus Node implementation
  static void focusField(BuildContext context , FocusNode currentNode , FocusNode nextNode){
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  static void toastMessage(String message , Color color){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}