import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Component {
  static customTextField(TextEditingController controller, String label, IconData icon, bool hide) {
    return TextFormField(
      controller: controller,
      obscureText: hide,
      validator: (value){
        bool isValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
        if(value.isEmpty || value==" "){
          return "Please Enter "+label;
        }
        else if(label=="Email Address"){
          if(!isValid){
            return "Enter Valid Email Address";
          }
        }
        else if(label=="Password"){
          if(value.length < 6){
            return "Password length must be greater than 6";
          }
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 3.w),
          // Border color when focused
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF50B612), width: 3.w),
          borderRadius: BorderRadius.circular(10), // Border color when not focused
        ),
      )
    );
  }


  static customButton(VoidCallback fun, String text) {
    return ElevatedButton(
      onPressed: () {
        fun();
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'ReadexPro',
          fontSize: 20.sp,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF278920),
        fixedSize: Size(350.w, 60.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
      ),
    );
  }

  static customNavigateButton(VoidCallback fun, String text1,String text2){
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 5.h, 0, 0),
          child: Text(
            text1,
            style: TextStyle(
              fontFamily: 'Readex Pro',
              color: Color(0xFF868A8D),
              fontSize: 16.sp,
            ),
          ),
        ),
        TextButton(
            onPressed: (){
              fun();
            },
            child: Text(
              text2,
              style: TextStyle(
                fontFamily: 'Readex Pro',
                color: Color(0xFF3A3939),
                fontSize: 16.sp,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
              ),
            )
        )
      ],
    );
  }

  static customError(bool showError){
    return Visibility(
      visible: showError,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Invalid credentials. Please try again.',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
