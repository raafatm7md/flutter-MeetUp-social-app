import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/views/app/social_cubit.dart';
import 'package:social_app/views/onboarding.dart';
import 'package:social_app/views/social_screens/reset_password.dart';
import 'package:social_app/views/widgets/widgets.dart';

import '../../services/dio.dart';
import '../../services/shared.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var birthdayController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = SocialCubit.get(context).user;
        nameController.text = user!.name!;
        emailController.text = user.email!;
        birthdayController.text = user.birthday!;
        return state is SocialEditingProfile
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                              SizedBox(
                                height: 15.0,
                              ),
                              appTextFormField(
                                  fieldController: emailController,
                                  inputType: TextInputType.emailAddress,
                                  label: 'Email',
                                  icon: Icons.email_outlined,
                                  fixed: true,
                                  type: 'email'),
                              SizedBox(
                                height: 15.0,
                              ),
                              appTextFormField(
                                  fieldController: birthdayController,
                                  inputType: TextInputType.phone,
                                  label: 'Birthday',
                                  icon: Icons.calendar_month,
                                  type: 'birthday',
                                  fixed: true)
                            ],
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                SocialCubit.get(context).updateData(
                                    newName: nameController.text);
                              }
                            },
                            child: Text('Done')),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(),));
                            },
                            child: Text('Reset password')),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  var passwordController =
                                      TextEditingController();
                                  var passFormKey = GlobalKey<FormState>();
                                  return Container(
                                    width: double.infinity,
                                    child: Dialog(
                                      backgroundColor: Colors.black,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 10.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Delete account',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 25.0)),
                                            Text('Please enter your password',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            Form(
                                              key: passFormKey,
                                              child: TextFormField(
                                                  controller:
                                                      passwordController,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: true,
                                                  validator: (value) {
                                                    if (value!.length < 8 ||
                                                        value.length > 30) {
                                                      return "Please enter the password correctly";
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    label: Text('password'),
                                                    prefixIcon: Icon(
                                                      Icons.lock,
                                                    ),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    if (passFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      DioHelper.deleteData(
                                                          url: 'profile/delete',
                                                          token: CacheHelper
                                                              .getData('token'),
                                                          query: {
                                                            'password':
                                                                passwordController
                                                                    .text
                                                          }).then((value) {
                                                            UserModel res = UserModel.fromJson(value.data);
                                                            if (res.status == true){
                                                              CacheHelper.removeData('token');
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        OnBoardingScreen(),
                                                                  ),
                                                                      (route) => false);
                                                            }
                                                            Fluttertoast.showToast(
                                                                msg: res.message!,
                                                                toastLength: Toast.LENGTH_SHORT,
                                                                gravity: ToastGravity.BOTTOM,
                                                                timeInSecForIosWeb: 1,
                                                                backgroundColor: Colors.red,
                                                                textColor: Colors.white,
                                                                fontSize: 16.0);
                                                      }).catchError((e) {
                                                        Fluttertoast.showToast(
                                                            msg: 'Check your internet connection',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0);
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Text('Delete account')),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              SocialCubit.get(context).logout();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OnBoardingScreen(),
                                  ),
                                  (route) => false);
                            },
                            child: Text('Logout')),
                      )
                    ],
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0)),
                                      image: DecorationImage(
                                        image: NetworkImage(user.cover != null
                                            ? '${user.cover}'
                                            : 'https://e0.pxfuel.com/wallpapers/135/566/desktop-wallpaper-purple-for-purple-damask-peach-flock-by-for-your-mobile-tablet-explore-purple-damask-black-and-purple-purple-thumbnail.jpg'),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.deepPurple,
                                      radius: 20.0,
                                      child: Icon(Icons.camera_enhance),
                                    ))
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 65.0,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: NetworkImage(user.image !=
                                          null
                                      ? '${user.image}'
                                      : 'https://i.pinimg.com/736x/c0/74/9b/c0749b7cc401421662ae901ec8f9f660.jpg'),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.deepPurple,
                                    radius: 18.0,
                                    child: Icon(
                                      Icons.camera_enhance,
                                      size: 22,
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      '${user.name}',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text('Add Post'),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            SocialCubit.get(context).editProfile();
                          },
                          child: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        'You don\'t have posts yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ))
                  ],
                ),
              );
      },
    );
  }
}
