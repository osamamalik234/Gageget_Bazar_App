import 'package:flutter/material.dart';

import '../utils/colors/my_color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  const AppButton({Key? key, required this.text, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: MyColor.primaryColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 20 , fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
