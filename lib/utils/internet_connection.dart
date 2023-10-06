import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../view/user_screens/internet_connection_checker.dart';

class CheckInternetConnection {
   void checkConnectivity(context) {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      if (connected == false) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InternetConnectionCheckerExample()));
      }
    });
// return true;
  }
}
