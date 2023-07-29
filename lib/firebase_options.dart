import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWOmxDtvlxSjHDMSPShPUgXQ4trCg8Cm4',
    appId: '1:346946969530:android:b7c02345e2b95662c08783',
    messagingSenderId: '346946969530',
    projectId: 'todo-a5f24',
    storageBucket: 'todo-a5f24.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAywaIEONtNO5LEe2RyMzxCvSUrGw6Hzcg',
    appId: '1:346946969530:ios:41eeeb9ea9b7b5d1c08783',
    messagingSenderId: '346946969530',
    projectId: 'todo-a5f24',
    storageBucket: 'todo-a5f24.appspot.com',
    iosClientId: '346946969530-h6rjjoofgb20op2f2hj68tfnj9ko8ts0.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterToDoList',
  );
}
