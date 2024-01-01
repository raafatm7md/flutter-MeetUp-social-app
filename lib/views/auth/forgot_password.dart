import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../cubits/reset_password/reset_password_cubit.dart';
import '../widgets/widgets.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var otpController = TextEditingController();
    var password1Controller = TextEditingController();
    var password2Controller = TextEditingController();

    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is OTPSent) {
            if (state.respond.message != null) {
              Fluttertoast.showToast(
                  msg: state.respond.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else {
              Fluttertoast.showToast(
                  msg: state.respond.errors![0],
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
          if (state is ConfirmOTPSuccess) {
            if (state.respond.status == false) {
              Fluttertoast.showToast(
                  msg: state.respond.message!,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
          if (state is ResetPasswordSuccess) {
            if (state.respond.message == 'Password changed successfully') {
              Fluttertoast.showToast(
                  msg: state.respond.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pop(context);
            } else if (state.respond.message != null){
              Fluttertoast.showToast(
                  msg: state.respond.message!,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state.respond.errors!.isNotEmpty){
              for (int i = 0; i < state.respond.errors!.length; i++) {
                Fluttertoast.showToast(
                    msg: state.respond.errors![i],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              }
          }
        },
        builder: (context, state) {
          if (ResetPasswordCubit.get(context).otpRespond?.status == true) {
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text('New password!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 36)),
                          SizedBox(
                            height: 40,
                          ),
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Text('Please enter a new password',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  appTextFormField(
                                      fieldController: password1Controller,
                                      inputType: TextInputType.visiblePassword,
                                      isPassword: true,
                                      label: 'New password',
                                      icon: Icons.password_outlined,
                                      type: 'password'),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  appTextFormField(
                                      fieldController: password2Controller,
                                      inputType: TextInputType.visiblePassword,
                                      isPassword: true,
                                      label: 'Confirm password',
                                      icon: Icons.lock_outline,
                                      type: 'password'),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  state is ResetPasswordLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : appButton(
                                          text: 'Reset',
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (password1Controller.text == password2Controller.text){
                                                ResetPasswordCubit.get(context)
                                                    .resetPassword(
                                                    otp: otpController.text,
                                                    password:
                                                    password1Controller
                                                        .text,
                                                    passwordConfirmation:
                                                    password2Controller
                                                        .text);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'password must be matched',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
                                            }
                                          },
                                        )
                                ],
                              ))
                        ],
                      ))),
            );
          } else if (ResetPasswordCubit.get(context).respond?.message ==
              'OTP sent successfully') {
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text('OTP sent successfully',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 36)),
                          SizedBox(
                            height: 40,
                          ),
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Text(
                                      'Please enter the OTP sent to your email',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  appTextFormField(
                                      fieldController: otpController,
                                      inputType: TextInputType.number,
                                      label: 'OTP',
                                      icon: Icons.access_time_outlined,
                                      type: 'otp'),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  state is ConfirmOTPLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : appButton(
                                          text: 'Confirm',
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              ResetPasswordCubit.get(context)
                                                  .confirmOTP(
                                                      otpController.text);
                                            }
                                          },
                                        )
                                ],
                              ))
                        ],
                      ))),
            );
          } else {
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text('Forgot password?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 36)),
                          SizedBox(
                            height: 40,
                          ),
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Text('Please enter your email',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  appTextFormField(
                                      fieldController: emailController,
                                      inputType: TextInputType.emailAddress,
                                      label: 'Email',
                                      icon: Icons.email_outlined,
                                      type: 'email'),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  state is SendOTPLoading
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : appButton(
                                          text: 'Send OTP',
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              ResetPasswordCubit.get(context)
                                                  .sendOTP(
                                                      emailController.text);
                                            }
                                          },
                                        )
                                ],
                              ))
                        ],
                      ))),
            );
          }
        },
      ),
    );
  }
}
