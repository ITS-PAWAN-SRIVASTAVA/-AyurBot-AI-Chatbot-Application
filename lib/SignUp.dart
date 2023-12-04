import 'package:ayurveda_chatbot/component.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';
import 'main2.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  signUp(String name,String email,String pass) async {       //signup page function
    if((email=='') || (pass=='') || (name=='')){
      //nothing
    }
    else{
      UserCredential?  usercredential;
      try{
        usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass).then((value){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const Home()));
        });
        await usercredential?.user?.updateDisplayName(name);
      }
      on FirebaseAuthException catch(ex){
        return ;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                            'Sign Up',
                            style: TextStyle(
                              fontFamily: 'ReadexPro',
                              fontSize: 43.sp,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        Component.customTextField(name, 'Name', Icons.person, false),
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
                            signUp(name.text.toString(), email.text.toString(), password.text.toString());
                          }
                        }, 'SIGN UP'),
                        Component.customNavigateButton(() {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Login()));
                        },"Already have an Account?","Login")
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
      ),
    );
  }
}
