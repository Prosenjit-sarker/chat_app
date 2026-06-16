import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('DefaultFirebaseOptions are only supported on the web.');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD-EXAMPLE-KEY-1234567890',
    authDomain: 'your-project-id.firebaseapp.com',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    messagingSenderId: '123456789012',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    measurementId: 'G-EXAMPLEMEASURE',
  );
}
