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
    apiKey: 'AIzaSyBGWtfsFEQOspdsNxdy6ihPzFvs9etP9j0',
    appId: '1:395123801284:web:2544575fc5c4a498fd1d91',
    messagingSenderId: '395123801284',
    projectId: 'powerstone-gym',
    authDomain: 'powerstone-gym.firebaseapp.com',
    storageBucket: 'powerstone-gym.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfKnKzm6ULzc7MOTuT5nni564Uvb0IecU',
    appId: '1:395123801284:android:b3c4468d6cca37fbfd1d91',
    messagingSenderId: '395123801284',
    projectId: 'powerstone-gym',
    storageBucket: 'powerstone-gym.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDg2BvXbgnV3pwCZvLfEr4hQ0lDEa7S_f0',
    appId: '1:395123801284:ios:be191f663bbe8bebfd1d91',
    messagingSenderId: '395123801284',
    projectId: 'powerstone-gym',
    storageBucket: 'powerstone-gym.appspot.com',
    iosBundleId: 'com.example.powerstone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDg2BvXbgnV3pwCZvLfEr4hQ0lDEa7S_f0',
    appId: '1:395123801284:ios:58714b702ec42881fd1d91',
    messagingSenderId: '395123801284',
    projectId: 'powerstone-gym',
    storageBucket: 'powerstone-gym.appspot.com',
    iosBundleId: 'com.example.powerstone.RunnerTests',
  );
}