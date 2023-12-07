import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/app_layout.dart';
import 'package:social_app/views/register/register_cubit.dart';
import 'package:social_app/views/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
              CacheHelper.saveData('token', state.token).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocialLayout(),
                    ),
                        (route) => false);
              });
          } else if (state is RegisterError) {
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
                      height: 200,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'SIGN UP',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            appTextFormField(
                                fieldController: nameController,
                                inputType: TextInputType.name,
                                label: 'Username',
                                icon: Icons.person,
                                type: 'username'),
                            const SizedBox(
                              height: 15,
                            ),
                            appTextFormField(
                                fieldController: emailController,
                                inputType: TextInputType.emailAddress,
                                label: 'Email',
                                icon: Icons.email_outlined,
                                type: 'email'),
                            const SizedBox(
                              height: 15,
                            ),
                            appTextFormField(
                                fieldController: passwordController,
                                inputType: TextInputType.visiblePassword,
                                isPassword: RegisterCubit.get(context).password,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                suffix: IconButton(
                                  icon: Icon(RegisterCubit.get(context).suffix),
                                  onPressed: () {
                                    RegisterCubit.get(context)
                                        .changePasswordVisibility();
                                  },
                                ),
                                type: 'password'),
                            const SizedBox(
                              height: 15,
                            ),
                            appTextFormField(
                                fieldController: birthdayController,
                                inputType: TextInputType.phone,
                                label: 'Birthday',
                                icon: Icons.calendar_month,
                                type: 'birthday',
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate:
                                              DateTime.parse('1900-01-01'),
                                          lastDate: DateTime.now())
                                      .then((value) {
                                    birthdayController.text =
                                        DateFormat.yMd().format(value!);
                                  });
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                            state is RegisterLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : appButton(
                                    text: 'SIGN UP',
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        RegisterCubit.get(context).userRegister(
                                            nameController.text,
                                            emailController.text,
                                            passwordController.text,
                                            birthdayController.text);
                                      }
                                    },
                                  ),
                          ],
                        ))
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
