import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food/custom_navigation_bar/custom_navigation_bar.dart';
import 'package:food/firebase/firebase_auth/firebase_auth_helpher.dart';
import 'package:food/provider/my_provider.dart';
import 'package:food/utils/colors/my_color.dart';
import 'package:food/utils/routes/routes.dart';
import 'package:food/utils/validation_utils/my_utilities.dart';
import 'package:food/view/main%20screens/user_home_screen.dart';
import 'package:food/view/user_screens/get_started.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Firebase Notifications/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      "pk_test_51MWx8OAVMyklfe3CsjEzA1CiiY0XBTlHYbZ8jQlGtVFIwQi4aNeGv8J1HUw4rgSavMTLzTwgn0XRlwoTVRFXyu2h00mRUeWmAf";
  FirebaseMessaging.onBackgroundMessage(_firebaseMessageOnBackgroundHandler);
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessageOnBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title.toString());
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  @override
  Widget build(BuildContext context) {
    FirebaseNotificationServices firebaseNotificationServices =
        FirebaseNotificationServices();
    firebaseNotificationServices.firebaseInit(context);
    firebaseNotificationServices.setBackAndTerminatedState(context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    // FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper();
    return ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: user == null ? GetStarted() : CustomNavigationBar(),
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
