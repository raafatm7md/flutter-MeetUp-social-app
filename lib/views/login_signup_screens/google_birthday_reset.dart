import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../services/shared.dart';
import '../app_layout.dart';
import '../cubits/google_signin/google_signin_cubit.dart';
import '../widgets/widgets.dart';

class GoogleBirthdayReset extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var birthdayController = TextEditingController();
  final String token;
  GoogleBirthdayReset({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoogleSigninCubit(),
      child: BlocConsumer<GoogleSigninCubit, GoogleSigninState>(
        listener: (context, state) {
          if (state is GoogleSigninUpdateDataSuccess) {
            CacheHelper.saveData('token', state.token).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SocialLayout(),
                  ),
                      (route) => false);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                              Text('Enter your birthday',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30.0)),
                              SizedBox(
                                height: 30.0,
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
                              SizedBox(
                                height: 30.0,
                              ),
                              state is GoogleSigninUpdateDataLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : appButton(
                                      text: 'Continue',
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          GoogleSigninCubit.get(context)
                                              .updateData(
                                                  birthday:
                                                      birthdayController.text, token: token);
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
        },
      ),
    );
  }
}
