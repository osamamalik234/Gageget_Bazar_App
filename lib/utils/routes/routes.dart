import 'package:flutter/material.dart';
import 'package:food/models/product_model/product_model.dart';
import 'package:food/utils/routes/route_name.dart';
import 'package:food/view/main%20screens/cart_screen.dart';
import 'package:food/view/user_screens/check_out_screen.dart';
import 'package:food/view/user_screens/favourite_cart_screen.dart';
import 'package:food/view/user_screens/change_password.dart';
import 'package:food/view/user_screens/edit_screen.dart';
import 'package:food/view/user_screens/get_started.dart';
import 'package:food/view/user_screens/product_details_screen.dart';
import 'package:food/view/main%20screens/user_home_screen.dart';

import '../../custom_navigation_bar/custom_navigation_bar.dart';
import '../../forget_password/forget_password.dart';
import '../../view/auth_screen/login_screen.dart';
import '../../view/auth_screen/signup_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.getStartedScreen:
        return MaterialPageRoute(builder: (_) => GetStarted());
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case RouteName.forgetPasswordScreen:
        return MaterialPageRoute(builder: (_) => ForgetPassword());
      case RouteName.userHomeScreen:
        return MaterialPageRoute(builder: (_) => UserHomeScreen());
      case RouteName.cartScreen:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case RouteName.favouriteScreen:
        return MaterialPageRoute(builder: (_) => FavouriteCartItem());
      case RouteName.customNavigationBar:
        return MaterialPageRoute(builder: (_) => CustomNavigationBar());
      case RouteName.editScreen:
        return MaterialPageRoute(builder: (_) => EditScreen());
      case RouteName.changePassowrd:
        return MaterialPageRoute(builder: (context) => ChangePasswordScreen());
      case RouteName.checkoutScreen:
        // return MaterialPageRoute(builder: (context) => CheckOutScreen());
        default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}