// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAw6vBLDcBMqjiAhoHKWxsOAlpAsg5Wcek',
    appId: '1:396987771355:web:c8fc6c0c56f5455fa71ffe',
    messagingSenderId: '396987771355',
    projectId: 'meetup-social-app',
    authDomain: 'meetup-social-app.firebaseapp.com',
    storageBucket: 'meetup-social-app.appspot.com',
    measurementId: 'G-6P79F592FD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXIeFUEEsPaqqkrJMs6fx0tyhPcL62MRc',
    appId: '1:396987771355:android:895d8ad9f7c679d2a71ffe',
    messagingSenderId: '396987771355',
    projectId: 'meetup-social-app',
    storageBucket: 'meetup-social-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBn_Wif5H6wv4xHjoHvxDShkjmWLXjfTqM',
    appId: '1:396987771355:ios:3afffe9d5be19009a71ffe',
    messagingSenderId: '396987771355',
    projectId: 'meetup-social-app',
    storageBucket: 'meetup-social-app.appspot.com',
    iosBundleId: 'com.meetup.app',
  );
}
