import 'package:flutter/material.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/font_family/my_font_family.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../view/main screens/cart_screen.dart';
import '../view/main screens/order_screen.dart';
import '../view/user_screens/favourite_cart_screen.dart';
import '../view/main screens/profile_screen.dart';
import '../view/main screens/user_home_screen.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final _controller = PersistentTabController(initialIndex: 0);
  List<Widget> _myBuildScreens() {
    return [
      UserHomeScreen(),
      CartScreen(),
      OrderScreen(),
      ProfileScreen(),
    ];
}

  List<PersistentBottomNavBarItem>  _persistentItem() {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.home),
          inactiveIcon: Icon(Icons.home_outlined),
          title: "Home",
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: MyFontFamily.serifFamily),
          inactiveColorPrimary: Colors.white,
          activeColorPrimary: Colors.white,

      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        inactiveIcon: Icon(Icons.shopping_cart_outlined),
        title: "Shopping",
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: MyFontFamily.serifFamily,),
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.white,

      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.circle),
        inactiveIcon: Icon(Icons.circle_outlined),
        title: "Orders",
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: MyFontFamily.serifFamily),
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.white,

      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_rounded),
        inactiveIcon: Icon(Icons.person_2_outlined),
        title: "Profile",
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: MyFontFamily.serifFamily),
        inactiveColorPrimary: Colors.white,
        activeColorPrimary: Colors.white,

      ),
    ];
}
   @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _myBuildScreens(),
        items: _persistentItem(),
        navBarStyle: NavBarStyle.style1,
        backgroundColor: MyColor.primaryColor,
    );
  }
}
