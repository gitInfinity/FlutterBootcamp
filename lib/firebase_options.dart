import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAHPjAB5e8NyPzKfcHEJuVO5KxKIGh7GcE',
    appId: '1:463246836586:web:c1e9045f73edea709d1b13',
    messagingSenderId: '463246836586',
    projectId: 'peachpaper-1c3a7',
    authDomain: 'peachpaper-1c3a7.firebaseapp.com',
    storageBucket: 'peachpaper-1c3a7.firebasestorage.app',
    measurementId: 'G-F3Z4MZVS5V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHhL3wPGrt03ym8_UZDvFybCmPiRYhymc',
    appId: '1:463246836586:android:2142340e4598d93b9d1b13',
    messagingSenderId: '463246836586',
    projectId: 'peachpaper-1c3a7',
    storageBucket: 'peachpaper-1c3a7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABy0hFsgTiiyM3NNn0MuzNp004h1KFW78',
    appId: '1:463246836586:ios:dc9a937b50c81d899d1b13',
    messagingSenderId: '463246836586',
    projectId: 'peachpaper-1c3a7',
    storageBucket: 'peachpaper-1c3a7.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABy0hFsgTiiyM3NNn0MuzNp004h1KFW78',
    appId: '1:463246836586:ios:dc9a937b50c81d899d1b13',
    messagingSenderId: '463246836586',
    projectId: 'peachpaper-1c3a7',
    storageBucket: 'peachpaper-1c3a7.firebasestorage.app',
    iosBundleId: 'com.example.notesApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAHPjAB5e8NyPzKfcHEJuVO5KxKIGh7GcE',
    appId: '1:463246836586:web:17d761273991caf89d1b13',
    messagingSenderId: '463246836586',
    projectId: 'peachpaper-1c3a7',
    authDomain: 'peachpaper-1c3a7.firebaseapp.com',
    storageBucket: 'peachpaper-1c3a7.firebasestorage.app',
    measurementId: 'G-SDMZEE44ET',
  );
}
