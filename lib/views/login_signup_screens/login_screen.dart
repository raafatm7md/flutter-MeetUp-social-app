import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/app_layout.dart';
import 'package:social_app/views/login/login_cubit.dart';
import 'package:social_app/views/social_screens/reset_password_screens/forgot_password.dart';
import 'package:social_app/views/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (state.loginModel.status == true) {
              CacheHelper.saveData('token', state.loginModel.user?.token);
              CacheHelper.saveData('user', [
                state.loginModel.user?.name,
                state.loginModel.user?.email,
                state.loginModel.user?.email_active,
                state.loginModel.user?.birthday,
                state.loginModel.user?.image,
                state.loginModel.user?.cover,
              ]);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SocialLayout(),
                  ),
                  (route) => false);
            } else {
              for (int i = 0; i < state.loginModel.errors!.length; i++) {
                Fluttertoast.showToast(
                    msg: state.loginModel.errors![i],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
              ;
              if (state.loginModel.message != null) {
                Fluttertoast.showToast(
                    msg: state.loginModel.message!,
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
          } else if (state is LoginError) {
            Fluttertoast.showToast(
                msg: state.error,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/pics/login.png',
                      height: 250,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('LOGIN',
                        style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appTextFormField(
                              fieldController: emailController,
                              inputType: TextInputType.emailAddress,
                              label: 'Email',
                              icon: Icons.email_outlined,
                              type: 'email',
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            appTextFormField(
                                fieldController: passwordController,
                                inputType: TextInputType.visiblePassword,
                                isPassword: LoginCubit.get(context).password,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                type: 'password',
                                onSubmit: (value) {
                                  if (formKey.currentState!.validate()) {
                                    LoginCubit.get(context).userLogin(
                                        emailController.text,
                                        passwordController.text);
                                  }
                                },
                                suffix: IconButton(
                                  icon: Icon(LoginCubit.get(context).suffix),
                                  onPressed: () {
                                    LoginCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordScreen(),
                                      ));
                                },
                                child: Text(
                                  'Forgot password?',
                                  textAlign: TextAlign.start,
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            state is LoginLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : appButton(
                                    text: 'LOGIN',
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        LoginCubit.get(context).userLogin(
                                            emailController.text,
                                            passwordController.text);
                                      }
                                    }),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
