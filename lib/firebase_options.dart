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
    apiKey: 'AIzaSyDMHQEHGJcaBm8pdGIAB5whV3uNpe4pc-4',
    appId: '1:842433810589:web:121b9b16f33d2cf9c8c474',
    messagingSenderId: '842433810589',
    projectId: 'uniwave-824e9',
    authDomain: 'uniwave-824e9.firebaseapp.com',
    storageBucket: 'uniwave-824e9.appspot.com',
    measurementId: 'G-0HSPLZB3H6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD0QER4YRSTHahAV7UO-cbdZm8dBByToas',
    appId: '1:842433810589:android:7df49be39d07bde9c8c474',
    messagingSenderId: '842433810589',
    projectId: 'uniwave-824e9',
    storageBucket: 'uniwave-824e9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7fGdPVMYNZjpKyygBNQfunkyTsjJgUD8',
    appId: '1:842433810589:ios:989fb8dff788e8ccc8c474',
    messagingSenderId: '842433810589',
    projectId: 'uniwave-824e9',
    storageBucket: 'uniwave-824e9.appspot.com',
    iosBundleId: 'com.example.ebook',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD7fGdPVMYNZjpKyygBNQfunkyTsjJgUD8',
    appId: '1:842433810589:ios:989fb8dff788e8ccc8c474',
    messagingSenderId: '842433810589',
    projectId: 'uniwave-824e9',
    storageBucket: 'uniwave-824e9.appspot.com',
    iosBundleId: 'com.example.ebook',
  );
}
