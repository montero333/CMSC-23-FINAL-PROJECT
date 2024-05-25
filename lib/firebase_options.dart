// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyAR-oLKA5uoLuLM9u_x2NLhwQZZoa7rn5s',
    appId: '1:1071802679277:web:9db1bb3ace36939d0bf1e4',
    messagingSenderId: '1071802679277',
    projectId: 'cmsc23-project-c30c1',
    authDomain: 'cmsc23-project-c30c1.firebaseapp.com',
    storageBucket: 'cmsc23-project-c30c1.appspot.com',
    measurementId: 'G-GJ1JHXYQ1B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDV_XnRZDD2bLyOomKAQ-ZWjyCxL9Fiy7M',
    appId: '1:1071802679277:android:45f126512d44d70d0bf1e4',
    messagingSenderId: '1071802679277',
    projectId: 'cmsc23-project-c30c1',
    storageBucket: 'cmsc23-project-c30c1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADDYcmFTjhxMaX8qdN-eJxcrYYnmPlZFc',
    appId: '1:1071802679277:ios:9c638fa1f0868d030bf1e4',
    messagingSenderId: '1071802679277',
    projectId: 'cmsc23-project-c30c1',
    storageBucket: 'cmsc23-project-c30c1.appspot.com',
    iosBundleId: 'com.example.milestone1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADDYcmFTjhxMaX8qdN-eJxcrYYnmPlZFc',
    appId: '1:1071802679277:ios:9c638fa1f0868d030bf1e4',
    messagingSenderId: '1071802679277',
    projectId: 'cmsc23-project-c30c1',
    storageBucket: 'cmsc23-project-c30c1.appspot.com',
    iosBundleId: 'com.example.milestone1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAR-oLKA5uoLuLM9u_x2NLhwQZZoa7rn5s',
    appId: '1:1071802679277:web:657e6de434e26c640bf1e4',
    messagingSenderId: '1071802679277',
    projectId: 'cmsc23-project-c30c1',
    authDomain: 'cmsc23-project-c30c1.firebaseapp.com',
    storageBucket: 'cmsc23-project-c30c1.appspot.com',
    measurementId: 'G-G3N0N3YQP1',
  );
}
