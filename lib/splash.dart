import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/splashicon.png'),
              width: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Ayurveda Bot',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(28, 82, 126, 1),
                fontSize: 30.sp,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: Text(
                'Unlock Ayurvedic Wisdom with AyurvedaBot',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(28, 82, 126, 1),
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 50),
            SpinKitFadingCircle(
              color: Color.fromRGBO(28, 82, 126, 1),
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
