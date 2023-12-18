import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/services/dio.dart';
import 'package:social_app/services/shared.dart';

import '../../models/reset_password_model.dart';
import '../widgets/widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordController2 = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text('Reset Password',
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0)),
                        SizedBox(
                          height: 30.0,
                        ),
                        appTextFormField(
                            fieldController: oldPasswordController,
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            label: 'Old password',
                            icon: Icons.lock_open_outlined,
                            type: 'password'),
                        SizedBox(
                          height: 15.0,
                        ),
                        appTextFormField(
                            fieldController: newPasswordController,
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            label: 'New password',
                            icon: Icons.lock_reset_outlined,
                            type: 'password'),
                        SizedBox(
                          height: 15.0,
                        ),
                        appTextFormField(
                            fieldController: newPasswordController2,
                            inputType: TextInputType.visiblePassword,
                            isPassword: true,
                            label: 'Confirm new password',
                            icon: Icons.lock_reset_outlined,
                            type: 'password'),
                        SizedBox(
                          height: 30.0,
                        ),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : appButton(
                                text: 'Reset',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (newPasswordController.text ==
                                        newPasswordController2.text) {
                                      if (newPasswordController.text ==
                                          oldPasswordController.text) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'New password must be different from the old password',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        setState(() {
                                          loading = true;
                                        });
                                        DioHelper.postData(
                                                url: 'profile/update_password',
                                                data: {
                                                  'old_password':
                                                      oldPasswordController
                                                          .text,
                                                  'password':
                                                      newPasswordController
                                                          .text,
                                                  'password_confirmation':
                                                      newPasswordController2
                                                          .text
                                                },
                                                token: CacheHelper.getData(
                                                    'token'))
                                            .then((value) {
                                          ResetPassModel res =
                                              ResetPassModel.fromJson(
                                                  value.data);
                                          if (res.status == true) {
                                            Fluttertoast.showToast(
                                                msg: res.message!,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            Navigator.pop(context);
                                          } else if (res.status == false) {
                                            Fluttertoast.showToast(
                                                msg: res.message!,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                          setState(() {
                                            loading = false;
                                          });
                                        }).catchError((e) {
                                          setState(() {
                                            loading = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: e.toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        });
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              'new password confirmation dosen\'t match new password',
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
            ),
          ),
        ),
      ),
    );
  }
}
