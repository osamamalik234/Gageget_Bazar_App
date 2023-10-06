import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/component/app_button.dart';
import 'package:food/component/text_field.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/font_family/my_font_family.dart';
import 'package:food/utils/images/my_images.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import '../utils/constants/constants.dart';
import '../utils/internet_connection.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  CheckInternetConnection checkInternetConnection = CheckInternetConnection();
  @override
  void initState() {
    checkInternetConnection.checkConnectivity(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    bool _obsecureText = false;
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios, color: Colors.black,),),
        title: Text(
          "Forget Screen",
          style: textStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Image.asset(MyImages.forgetPasswordImage),
                Text(
                  "Please Enter your Email to recover\n                    the password.",
                  style: TextStyle(
                      fontSize: 18, fontFamily: MyFontFamily.serifFamily),
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormFieldComponent(
                    controller: _emailController,
                    onFieldSubmittedValue: (value) {},
                    onValidator: (value) {
                      return value.isEmpty ? "Enter Email" : null;
                    },
                    keyBoardType: TextInputType.emailAddress,
                    hint: "Enter Email",
                    obsecureText: _obsecureText,
                    prefixIcon: Icons.email,),
                SizedBox(
                  height: 40,
                ),
                AppButton(text: "Forget Password", onPress: () {
                   showDialogBox(context);
                  _auth.sendPasswordResetEmail(email: _emailController.text).then((value){
                    MyUtilities.toastMessage("Email has been sent to you please check it", MyColor.primaryColor);
                    Navigator.of(context).pop();
                  });
                  setState(() {
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
