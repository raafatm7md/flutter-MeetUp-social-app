import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/services/shared.dart';
import 'package:social_app/views/widgets/widgets.dart';

import '../../services/dio.dart';
import '../app_layout.dart';

class FingerprintScreen extends StatefulWidget {
  const FingerprintScreen({super.key});

  @override
  State<FingerprintScreen> createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {
  late final LocalAuthentication auth;
  bool supportState = false;
  bool loadingState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (value) {
        setState(() {
          supportState = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Icon(
              Icons.fingerprint,
              size: 240.0,
              color: Colors.deepPurple,
            )),
            SizedBox(
              height: 50,
            ),
            supportState
                ? loadingState
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : appButton(
                        text: 'LOGIN',
                        onPressed: () {
                          getAvailableBiometrics();
                          authenticate();
                        },
                      )
                : Text(
                    'Fingerprint is not supported',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print(availableBiometrics);
    if (!mounted) {
      return;
    }
  }

  Future<void> authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Login with fingerprint',
          options:
              AuthenticationOptions(stickyAuth: true, biometricOnly: true));
      if (authenticated == true) {
        if (CacheHelper.getData('cachedEmail') != null &&
            CacheHelper.getData('cachedPassword') != null) {
          loadingState = true;
          setState(() {});
          DioHelper.postData(url: 'login', data: {
            'email': CacheHelper.getData('cachedEmail'),
            'password': CacheHelper.getData('cachedPassword')
          }).then((value) {
            loadingState = false;
            setState(() {});
            var res = LoginModel.fromJson(value.data);
            if (res.status == true) {
              CacheHelper.saveData('token', res.user?.token).then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocialLayout(),
                    ),
                        (route) => false);
              });
            } else {
              Fluttertoast.showToast(
                  msg: 'login failed',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }).catchError((e) {
            loadingState = false;
            setState(() {});
            print(e.toString());
          });
        } else {
          Fluttertoast.showToast(
              msg: 'no linked account',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: 'not authenticated',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
