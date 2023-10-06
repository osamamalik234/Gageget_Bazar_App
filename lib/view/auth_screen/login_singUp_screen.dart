import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food/component/app_button.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/font_family/my_font_family.dart';
import 'package:food/utils/images/my_images.dart';
import 'package:food/view/auth_screen/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../utils/routes/route_name.dart';
import 'login_screen.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                "Welcome",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: MyFontFamily.serifFamily),
              ),
              Text(
                "Buy any item using this App",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    fontFamily: MyFontFamily.serifFamily),
              ),
              SizedBox(
                height: 30,
              ),
              Image.asset(
                MyImages.shopImage,
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isSigningIn = true;
                  });
                  User? user = await signInWithGoogle(context);
                  setState(() {
                    _isSigningIn = false;
                  });
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 8, right: 20, bottom: 8),
                    child: _isSigningIn
                        ? SpinKitSpinningLines(
                            color: MyColor.primaryColor,
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image: AssetImage(MyImages.googleImage),
                                height: 35.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 70,
              ),
              AppButton(
                text: "Login",
                onPress: () {
                  Navigator.pushNamed(context, RouteName.loginScreen);
                },
              ),
              SizedBox(
                height: 30,
              ),
              AppButton(
                text: "Sign up",
                onPress: () {
                  Navigator.pushNamed(context, RouteName.signUpScreen);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<User?> signInWithGoogle(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
// handle the error here
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'The account already exists with a different credential.',
          ),
        );
      } else if (e.code == 'invalid-credential') {
// handle the error here
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: 'Error occurred while accessing credentials. Try again.',
          ),
        );
      }
    } catch (e) {
// handle the error here
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Error occurred using Google Sign-In. Try again.',
        ),
      );
    }
  }

  return user;
}

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
  );
}
