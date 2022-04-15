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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDmiVNPu9XHzrxxaGLbc3OYAu9YWogrPHM',
    appId: '1:705214352014:web:45d2d32d357cae57ee17df',
    messagingSenderId: '705214352014',
    projectId: 'eloit-c4540',
    authDomain: 'eloit-c4540.firebaseapp.com',
    storageBucket: 'eloit-c4540.appspot.com',
    measurementId: 'G-VJ6E55K7C1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNgjPDfc-Buvglan3Pd5h554MrVxze2wc',
    appId: '1:705214352014:android:5cb31e0d05186a0aee17df',
    messagingSenderId: '705214352014',
    projectId: 'eloit-c4540',
    storageBucket: 'eloit-c4540.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC26EuNBQxvrvKXdVhaEW4BqRkEAkRrZig',
    appId: '1:705214352014:ios:da549675241ad11aee17df',
    messagingSenderId: '705214352014',
    projectId: 'eloit-c4540',
    storageBucket: 'eloit-c4540.appspot.com',
    iosClientId:
        '705214352014-1r32lusgi6o2peh6bb5rc5u7340uc1rd.apps.googleusercontent.com',
    iosBundleId: 'com.example.eloit',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC26EuNBQxvrvKXdVhaEW4BqRkEAkRrZig',
    appId: '1:705214352014:ios:da549675241ad11aee17df',
    messagingSenderId: '705214352014',
    projectId: 'eloit-c4540',
    storageBucket: 'eloit-c4540.appspot.com',
    iosClientId:
        '705214352014-1r32lusgi6o2peh6bb5rc5u7340uc1rd.apps.googleusercontent.com',
    iosBundleId: 'com.example.eloit',
  );
}
