import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/dio.dart';
import 'package:social_app/services/google_sign_in.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/login_signup_screens/face_id.dart';
import 'package:social_app/views/login_signup_screens/fingerprint_login.dart';
import 'package:social_app/views/login_signup_screens/google_birthday_reset.dart';
import 'package:social_app/views/login_signup_screens/login_screen.dart';
import 'package:social_app/views/login_signup_screens/register_screen.dart';
import 'package:social_app/views/widgets/widgets.dart';

import 'app_layout.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10.0,
            ),
            Image.asset('assets/pics/hello.png'),
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Hello',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
                'Welcome to MeetUp, Get ready to dive into a world of connections and creativity',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center),
            SizedBox(
              height: 40.0,
            ),
            appButton(
                text: 'Login',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                }),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    backgroundColor: Colors.black,
                    fixedSize: Size(double.maxFinite, 50),
                    alignment: AlignmentDirectional.center,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.deepPurple))),
                child: Text(
                  'Sign Up',
                  style: const TextStyle(fontSize: 16),
                )),
            Spacer(),
            Text(
              'or continue with',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.small(
                  onPressed: () async {
                    var auth = await GoogleSignInService.login();
                    if (auth.user?.uid != null) {
                      DioHelper.postData(
                          url: 'login/google/callback/${auth.user?.uid}',
                          data: {}).then((value) {
                        UserModel userRes = UserModel.fromJson(value.data);
                        if (userRes.status == true) {
                          if (userRes.user?.birthday == null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GoogleBirthdayReset(token: userRes.user!.token!),
                                ));
                          } else {
                            CacheHelper.saveData('token', userRes.user?.token).then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SocialLayout(),
                                  ),
                                      (route) => false);
                            });
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Something went wrong!',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }).catchError((e) {
                        print(e.toString());
                      });
                    }
                  },
                  heroTag: 'google',
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Image.asset('assets/pics/Google__G__Logo.png',
                      height: 25),
                  shape: CircleBorder(),
                ),
                SizedBox(
                  width: 10.0,
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceIdScreen(),
                        ));
                  },
                  heroTag: 'faceId',
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Image.asset('assets/pics/face.png', height: 25),
                  shape: CircleBorder(),
                ),
                SizedBox(
                  width: 10.0,
                ),
                FloatingActionButton.small(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FingerprintScreen(),
                        ));
                  },
                  heroTag: 'fingerprint',
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.fingerprint, size: 30.0),
                  shape: CircleBorder(),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
