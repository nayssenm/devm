// lib/firebase_options.dart
// Exemple minimal — remplace les valeurs par celles de ton projet Firebase.

import 'package:firebase_core/firebase_core.dart';

/// Classe minimale pour fournir les options Firebase attendues par
/// `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Ici on retourne Android pour simplifier.
    // Tu peux améliorer pour iOS/web si nécessaire.
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: '1:YOUR_SENDER_ID:android:YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET', // optionnel
    authDomain: null,
    measurementId: null,
  );

  // si tu veux ajouter iOS ou web, tu peux ajouter d'autres FirebaseOptions
  // static const FirebaseOptions ios = FirebaseOptions(...);
  // static const FirebaseOptions web = FirebaseOptions(...);
}

