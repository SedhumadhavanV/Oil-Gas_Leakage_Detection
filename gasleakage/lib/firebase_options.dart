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
        return macos;
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
    apiKey: 'AIzaSyCDRZFPX4dchht4o_Ay_1gw39XkIaFmAF8',
    appId: '1:795343839654:web:34ea05eae01833f78b6f67',
    messagingSenderId: '795343839654',
    projectId: 'gasleakage-5ea04',
    authDomain: 'gasleakage-5ea04.firebaseapp.com',
    databaseURL: 'https://gasleakage-5ea04-default-rtdb.firebaseio.com',
    storageBucket: 'gasleakage-5ea04.appspot.com',
    measurementId: 'G-FP50JXB2KC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCmi-2PhJiRAFg9jCglscl2fVdI-USPPaA',
    appId: '1:795343839654:android:4d92859c2ba0e4718b6f67',
    messagingSenderId: '795343839654',
    projectId: 'gasleakage-5ea04',
    databaseURL: 'https://gasleakage-5ea04-default-rtdb.firebaseio.com',
    storageBucket: 'gasleakage-5ea04.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8-c8w6jzbsFJFnz58S8KEz4Mrm6RtsRU',
    appId: '1:795343839654:ios:48d97b2f66d4930d8b6f67',
    messagingSenderId: '795343839654',
    projectId: 'gasleakage-5ea04',
    databaseURL: 'https://gasleakage-5ea04-default-rtdb.firebaseio.com',
    storageBucket: 'gasleakage-5ea04.appspot.com',
    iosBundleId: 'com.example.gasleakage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8-c8w6jzbsFJFnz58S8KEz4Mrm6RtsRU',
    appId: '1:795343839654:ios:3baa5962afc916ce8b6f67',
    messagingSenderId: '795343839654',
    projectId: 'gasleakage-5ea04',
    databaseURL: 'https://gasleakage-5ea04-default-rtdb.firebaseio.com',
    storageBucket: 'gasleakage-5ea04.appspot.com',
    iosBundleId: 'com.example.gasleakage.RunnerTests',
  );
}
