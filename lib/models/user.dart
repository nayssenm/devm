import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String nom;
  final String email;
  final String telephone;
  final String photoUrl;
  final DateTime dateInscription;
  final List<String> preferences;
  final double noteMoyenne;
  final String verification;
  final String role;

  UserModel({
    required this.uid,
    required this.nom,
    required this.email,
    this.telephone = '',
    this.photoUrl = '',
    DateTime? dateInscription,
    List<String>? preferences,
    this.noteMoyenne = 0.0,
    this.verification = 'none',
    this.role = 'passager',
  })  : dateInscription = dateInscription ?? DateTime.now(),
        preferences = preferences ?? [];

  factory UserModel.fromMap(Map<String, dynamic> m) => UserModel(
    uid: m['uid'] ?? '',
    nom: m['nom'] ?? '',
    email: m['email'] ?? '',
    telephone: m['telephone'] ?? '',
    photoUrl: m['photoUrl'] ?? '',
    dateInscription: (m['dateInscription'] is Timestamp) ? (m['dateInscription'] as Timestamp).toDate() : DateTime.now(),
    preferences: List<String>.from(m['preferences'] ?? []),
    noteMoyenne: (m['noteMoyenne'] ?? 0).toDouble(),
    verification: m['verification'] ?? 'none',
    role: m['role'] ?? 'passager',
  );

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'nom': nom,
    'email': email,
    'telephone': telephone,
    'photoUrl': photoUrl,
    'dateInscription': Timestamp.fromDate(dateInscription),
    'preferences': preferences,
    'noteMoyenne': noteMoyenne,
    'verification': verification,
    'role': role,
  };
}
