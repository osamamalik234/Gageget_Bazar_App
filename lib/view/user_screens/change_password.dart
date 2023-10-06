import 'package:flutter/material.dart';
import 'package:food/component/app_button.dart';
import 'package:food/component/text_field.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';

import '../../utils/constants/constants.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _oldPassword = TextEditingController();
    final _newPassword = TextEditingController();
    final _confirmPassword = TextEditingController();
    bool _obscureText = false;
    FirebaseAuthHelper _firebaseAuthHelper = FirebaseAuthHelper();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          "Change Password",
          style: textStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormFieldComponent(
              controller: _oldPassword,
              onFieldSubmittedValue: (value) {},
              onValidator: (value) {
                return null;
              },
              prefixIcon: Icons.password_outlined,
              keyBoardType: TextInputType.visiblePassword,
              hint: "Old Password",
              obsecureText: _obscureText,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormFieldComponent(
              controller: _newPassword,
              onFieldSubmittedValue: (value) {},
              onValidator: (value) {
                return null;
              },
              prefixIcon: Icons.password_outlined,
              keyBoardType: TextInputType.visiblePassword,
              hint: "New Password",
              obsecureText: _obscureText,
            ),
            SizedBox(
              height: 20,
            ),
            StatefulBuilder(builder: (context, internalState) {
              return TextFormFieldComponent(
                controller: _confirmPassword,
                // focusNode: passNode,
                onFieldSubmittedValue: (value) {
                  // MyUtilities.focusField(context, passNode, emailNode);
                },
                onValidator: (value) {
                  return value.isEmpty ? "Enter Password" : null;
                },
                keyBoardType: TextInputType.name,
                hint: "Confirm Password",
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
            SizedBox(
              height: 40,
            ),
            AppButton(
                text: "Change password",
                onPress: () {
                  bool isValidate = validateUpdatePassword(_oldPassword.text,
                      _newPassword.text, _confirmPassword.text);
                  if (isValidate) {
                    if (_confirmPassword.text == _newPassword.text) {
                      _firebaseAuthHelper.changePasswordMethod(
                          _oldPassword.text, _newPassword.text, context);
                    } else {
                      MyUtilities.toastMessage(
                          "Confirm password is not equal to new Password",
                          MyColor.errorColor);
                    }
                  }
                })
          ],
        ),
      ),
    );
  }
}
