import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget appButton({
  Color color = Colors.deepPurple,
  required String text,
  required void Function() onPressed,
}) =>
    ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: color,
            fixedSize: Size(double.maxFinite, 50),
            alignment: AlignmentDirectional.center,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ));

Widget appTextFormField({
  required TextEditingController fieldController,
  required TextInputType inputType,
  required String label,
  required IconData icon,
  required String type,
  bool isPassword = false,
  void Function(String)? onSubmit,
  void Function()? onTap,
  Widget? suffix,
  bool fixed = false
}) =>
    TextFormField(
      obscureText: isPassword,
      controller: fieldController,
      keyboardType: inputType,
      enabled: !fixed,
      validator: (value) {
        if (type == 'email'){
          if (isEmail(value!)) {
            return null;
          }
          return "Please enter a correct email";
        } else if (type == 'password'){
          if (value!.length < 8) {
            return "Password is too short";
          } else if (value.length > 30){
            return "Password is too long";
          }
          return null;
        } else if (type == 'username'){
          if (value!.isEmpty || value.contains(' ')) {
            return "Please enter available username";
          }
          return null;
        } else if (type == 'birthday'){
          if (value!.isEmpty) {
            return 'Please enter your birthday';
          } else {
            final DateTime now = DateTime.now();
            String str1 = value;
            List<String> str2 = str1.split('/');
            int month = int.parse(str2.isNotEmpty ? str2[0] : '');
            int day = int.parse(str2.length > 1 ? str2[1] : '');
            int year = int.parse(str2.length > 2 ? str2[2] : '');
            if (month > 12) {
              return 'Invalid month';
            } else if (day > 31) {
              return 'Invalid day';
            } else if ((now.year-year)*365 + (now.month-month)*30 + (now.day-day) < (16*365)) {
              // (int.parse(year) > int.parse(formatted)-18)
              return 'Must be older than 16 years';
            } else if((year < 1920)){
              return 'Invalid year';
            }
          }
          return null;
        } else if (type == 'otp'){
          if (value?.length != 4) {
            return "Please enter correct OTP";
          }
          return null;
        }
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.grey[900],
          label: Text(label),
          labelStyle: TextStyle(color: Colors.deepPurple[300]),
          prefixIcon: Icon(
            icon,
            color: Colors.deepPurple[300],
          ),
        suffixIcon: suffix
      ),
      onFieldSubmitted: onSubmit,
      onTap: onTap,
    );

bool isEmail(String email) {
  String regularExpression =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(regularExpression);
  return regExp.hasMatch(email);
}