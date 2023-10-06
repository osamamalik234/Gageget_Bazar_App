import 'package:cupertino_text_button/cupertino_text_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/utils/constants/constants.dart';
import 'package:food/utils/routes/route_name.dart';
import 'package:image_picker/image_picker.dart';
import '../../component/app_button.dart';
import '../../component/text_field.dart';
import '../../utils/colors/my_color.dart';
import '../../utils/font_family/my_font_family.dart';
import '../../utils/internet_connection.dart';
import '../../utils/validation_utils/my_utilities.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool _obscureText = false;
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode passNode = FocusNode();

  CheckInternetConnection checkInternetConnection = CheckInternetConnection();
  @override
  void initState() {
    checkInternetConnection.checkConnectivity(context);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _phoneNumber.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  // bool _obscureText = false;
  Uint8List? image;
  void takeMyPicture() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    XFile? _image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_image != null) {
      return _image.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      image == null
                          ? Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: MyColor.primaryColor, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: MyColor.primaryColor, size: 100,),
                        ),
                      )
                          : CircleAvatar(
                        radius: 70,
                        backgroundImage: MemoryImage(image!),
                      ),
                      Positioned(
                        bottom: -7,
                        right: -8,
                        child: IconButton(
                            onPressed: () {
                              takeMyPicture();
                            },
                            icon: Icon(
                             Icons.camera_alt,
                              color: MyColor.primaryColor,
                              size: 30,
                            )),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: MyColor.primaryColor,
                          fontFamily: MyFontFamily.serifFamily,
                        ),
                      ),
                      Text(
                        "It's quick and easy",
                        style: TextStyle(
                            fontSize: 18, fontFamily: MyFontFamily.serifFamily),
                      ),
                    ],
                  )
                ],
              ),


              // SizedBox(
              //   height: 40,
              // ),
              // Align(
              //     alignment: Alignment.center,
              //     child: Text(
              //       "Please Enter your details to create\n           free account Now!",
              //       style: TextStyle(
              //           fontSize: 18, fontFamily: MyFontFamily.serifFamily),
              //     )),
              const SizedBox(
                height: 40,
              ),
              TextFormFieldComponent(
                controller: _nameController,
                onFieldSubmittedValue: (value) {
                  MyUtilities.focusField(context, nameNode, phoneNode);
                },
                onValidator: (value) {
                  return value.isEmpty ? "Enter Name" : null;
                },
                keyBoardType: TextInputType.name,
                hint: "Name",
                obsecureText: _obscureText,
                prefixIcon: Icons.person_rounded,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormFieldComponent(
                controller: _phoneNumber,
                onFieldSubmittedValue: (value) {
                  MyUtilities.focusField(context, phoneNode, emailNode);
                },
                onValidator: (value) {
                  return value.isEmpty ? "Enter Number" : null;
                },
                keyBoardType: TextInputType.number,
                hint: "Phone Number",
                obsecureText: _obscureText,
                prefixIcon: Icons.phone,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormFieldComponent(
                controller: _emailController,
                focusNode: emailNode,
                onFieldSubmittedValue: (value) {
                  MyUtilities.focusField(context, emailNode, passNode);
                },
                onValidator: (value) {
                  return value.isEmpty ? "Enter Email" : null;
                },
                keyBoardType: TextInputType.emailAddress,
                hint: "Email",
                obsecureText: _obscureText,
                prefixIcon: Icons.email,
              ),
              const SizedBox(
                height: 20,
              ),
              StatefulBuilder(builder: (context, internalState) {
                return TextFormFieldComponent(
                  controller: _passController,
                  focusNode: passNode,
                  onFieldSubmittedValue: (value) {
                    MyUtilities.focusField(context, passNode, emailNode);
                  },
                  onValidator: (value) {
                    return value.isEmpty ? "Enter Password" : null;
                  },
                  keyBoardType: TextInputType.emailAddress,
                  hint: "Password",
                  obsecureText: _obscureText,
                  prefixIcon: Icons.lock,
                  suffixIcon:
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                  onIconPress: () {
                    internalState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                );
              }),
              const SizedBox(
                height: 50,
              ),
              AppButton(
                text: "Sign Up",
                onPress: () async {
                  bool isValidate = signUpValidation(
                      _nameController.text,
                      _phoneNumber.text,
                      _emailController.text,
                      _passController.text,image);
                  if (isValidate) {
                    bool isSignedUp = await firebaseAuthHelper.signUp(
                      _nameController.text,
                      _phoneNumber.text,
                      _emailController.text,
                      _passController.text,
                      image,
                      context,
                    );
                    if (isSignedUp) {
                      MyUtilities.toastMessage(
                          "Account has been created", MyColor.primaryColor);
                      Navigator.pushNamed(context, RouteName.loginScreen);
                    }
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  CupertinoTextButton(
                    text: "Login",
                    style: TextStyle(
                        // color: MyColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.underline),
                    color: MyColor.primaryColor,
                    pressedColor: MyColor.primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, RouteName.loginScreen);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
