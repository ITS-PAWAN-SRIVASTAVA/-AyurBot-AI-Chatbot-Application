import 'package:ayurveda_chatbot/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_ , child) {
        return MaterialApp(
        debugShowCheckedModeBanner: false,  //To not show debug banner
        home: Scaffold( //To not overflow when keyboard arrive
          body: SplashScreen()
        ),
      );
      },
      designSize: const Size(390, 844),
    );
  }
}

