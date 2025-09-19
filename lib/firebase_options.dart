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
    apiKey: 'AIzaSyCruwJQ6oRUKyUYG8GhhD-DbxtP1J3S2LY',
    appId: '1:2369258151:web:e682c67c6cc6ba864a9182',
    messagingSenderId: '2369258151',
    projectId: 'gocheck-7bf05',
    authDomain: 'gocheck-7bf05.firebaseapp.com',
    storageBucket: 'gocheck-7bf05.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCruwJQ6oRUKyUYG8GhhD-DbxtP1J3S2LY',
    appId: '1:2369258151:android:e682c67c6cc6ba864a9182',
    messagingSenderId: '2369258151',
    projectId: 'gocheck-7bf05',
    storageBucket: 'gocheck-7bf05.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCruwJQ6oRUKyUYG8GhhD-DbxtP1J3S2LY',
    appId: '1:2369258151:ios:e682c67c6cc6ba864a9182',
    messagingSenderId: '2369258151',
    projectId: 'gocheck-7bf05',
    storageBucket: 'gocheck-7bf05.firebasestorage.app',
  );
}
