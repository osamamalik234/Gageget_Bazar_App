import 'package:flutter/material.dart';
import 'package:food/utils/colors/my_color.dart';

class TextFormFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FormFieldSetter onFieldSubmittedValue;
  final FormFieldValidator onValidator;
  final TextInputType keyBoardType;
  final String hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obsecureText, enable, autofocus;
  Function()? onIconPress;
  final ValueChanged<String>? onChanged;
  TextFormFieldComponent(
      {Key? key,
      required this.controller,
      this.focusNode,
      required this.onFieldSubmittedValue,
      required this.onValidator,
      required this.keyBoardType,
      required this.hint,
      required this.obsecureText,
      this.suffixIcon,
      this.prefixIcon,
      this.onIconPress,
      this.enable = true,
      this.autofocus = false,
        this.onChanged,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyBoardType,
      onFieldSubmitted: onFieldSubmittedValue,
      validator: onValidator,
      onChanged: onChanged,
      obscureText: obsecureText,
      cursorColor: MyColor.primaryColor,
      decoration: InputDecoration(
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColor.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(prefixIcon , color: MyColor.primaryColor,),
        suffixIcon: InkWell(onTap: onIconPress, child: Icon(suffixIcon , color: MyColor.primaryColor,)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: MyColor.primaryColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
