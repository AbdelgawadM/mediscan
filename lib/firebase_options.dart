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
    apiKey: 'AIzaSyDfQyHBJmVVVlxnegYBWpGZq-8-snW2VGg',
    appId: '1:665981264411:web:480825c4624b9e14290ebe',
    messagingSenderId: '665981264411',
    projectId: 'mediscan-6d4f5',
    authDomain: 'mediscan-6d4f5.firebaseapp.com',
    storageBucket: 'mediscan-6d4f5.firebasestorage.app',
    measurementId: 'G-3D7F176TSQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAMIH0WXFHEch1DHcB8j2qzGBtUpGfMrws',
    appId: '1:665981264411:android:be5ff3c29724558e290ebe',
    messagingSenderId: '665981264411',
    projectId: 'mediscan-6d4f5',
    storageBucket: 'mediscan-6d4f5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOpO3EWjdFuyJTIr-lviOfD3kX4NR57fw',
    appId: '1:665981264411:ios:fd8afbd78fea654e290ebe',
    messagingSenderId: '665981264411',
    projectId: 'mediscan-6d4f5',
    storageBucket: 'mediscan-6d4f5.firebasestorage.app',
    iosBundleId: 'com.example.mediscan',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOpO3EWjdFuyJTIr-lviOfD3kX4NR57fw',
    appId: '1:665981264411:ios:fd8afbd78fea654e290ebe',
    messagingSenderId: '665981264411',
    projectId: 'mediscan-6d4f5',
    storageBucket: 'mediscan-6d4f5.firebasestorage.app',
    iosBundleId: 'com.example.mediscan',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDfQyHBJmVVVlxnegYBWpGZq-8-snW2VGg',
    appId: '1:665981264411:web:d0ee511aa311d52a290ebe',
    messagingSenderId: '665981264411',
    projectId: 'mediscan-6d4f5',
    authDomain: 'mediscan-6d4f5.firebaseapp.com',
    storageBucket: 'mediscan-6d4f5.firebasestorage.app',
    measurementId: 'G-ELNGQC4EN1',
  );
}
