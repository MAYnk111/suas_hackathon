import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart' show TargetPlatform;

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
    apiKey: 'AIzaSyDm7qF8k7sF0vF8k7sF0vF8k7sF0vF8k7s',
    appId: '1:123456789:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789',
    projectId: 'sudha-healthcare',
    authDomain: 'sudha-healthcare.firebaseapp.com',
    databaseURL: 'https://sudha-healthcare.firebaseio.com',
    storageBucket: 'sudha-healthcare.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDm7qF8k7sF0vF8k7sF0vF8k7sF0vF8k7s',
    appId: '1:123456789:android:abcdef1234567890abcdef',
    messagingSenderId: '123456789',
    projectId: 'sudha-healthcare',
    databaseURL: 'https://sudha-healthcare.firebaseio.com',
    storageBucket: 'sudha-healthcare.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDm7qF8k7sF0vF8k7sF0vF8k7sF0vF8k7s',
    appId: '1:123456789:ios:abcdef1234567890abcdef',
    messagingSenderId: '123456789',
    projectId: 'sudha-healthcare',
    databaseURL: 'https://sudha-healthcare.firebaseio.com',
    storageBucket: 'sudha-healthcare.appspot.com',
    iosBundleId: 'com.sudha.app',
  );
}
