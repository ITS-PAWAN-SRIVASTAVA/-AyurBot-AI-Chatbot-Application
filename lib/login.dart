import 'package:ayurveda_chatbot/component.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'SignUp.dart';
import 'main2.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool showError = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Login(String email,String pass) async {       //signup page function
    if((email=='') || (pass=='') ){
      //nothing
    }
    else{
      UserCredential?  usercredential;
      try{
        usercredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass).then((value){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Home()));
        });
      }
      on FirebaseAuthException catch(ex){
        setState(() {
          showError = true;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background (1).png'), // Replace with your image path
              fit: BoxFit.fill, // Adjust as needed
            ),
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 200.h, 0, 0),
                child: Container(
                  width: 320.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10.h),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'ReadexPro',
                            fontSize: 43.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text('Please Continue for Sign-in',style: TextStyle(fontFamily: 'ReadexPro',fontWeight: FontWeight.w500),),
                      SizedBox(
                        height: 100.h,
                      ),
                      Component.customError(showError),
                      SizedBox(
                        height: 30.h,
                      ),
                      Component.customTextField(email, 'Email Address', Icons.email, false),
                      SizedBox(
                        height: 30.h,
                      ),
                      Component.customTextField(password, 'Password', Icons.lock, true),
                      SizedBox(
                        height: 80.h,
                      ),
                      Component.customButton(() {
                        if (_formKey.currentState!.validate()) {
                          Login(email.text.toString(), password.text.toString());
                        }
                      }, 'LOGIN'),
                      Component.customNavigateButton(() {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));
                      },"Don't have an Account?","Sign Up")
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
