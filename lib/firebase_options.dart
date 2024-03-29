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
    apiKey: 'AIzaSyAYDJZLYeQCVHpDynnUZzGgOOh8pwdHVaY',
    appId: '1:1055795171705:web:1d20017217e3f254c45fa8',
    messagingSenderId: '1055795171705',
    projectId: 'instagram-clone-flutter-30245',
    authDomain: 'instagram-clone-flutter-30245.firebaseapp.com',
    storageBucket: 'instagram-clone-flutter-30245.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiB2-0gsuOFJ8A2VoXNex9m6zVtFIts0w',
    appId: '1:1055795171705:android:d663160f9b3aced9c45fa8',
    messagingSenderId: '1055795171705',
    projectId: 'instagram-clone-flutter-30245',
    storageBucket: 'instagram-clone-flutter-30245.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMBA-X6COOm_0anct4ZT5EBMvRxdFBvp4',
    appId: '1:1055795171705:ios:3f3b5942c4f9d7b6c45fa8',
    messagingSenderId: '1055795171705',
    projectId: 'instagram-clone-flutter-30245',
    storageBucket: 'instagram-clone-flutter-30245.appspot.com',
    iosBundleId: 'com.example.projectWithAndroid',
  );
}
