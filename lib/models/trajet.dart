import 'package:cloud_firestore/cloud_firestore.dart';

class TrajetModel {
  final String id;
  final String conducteurId;
  final GeoPoint depart;
  final String departAdresse;
  final GeoPoint arrivee;
  final String arriveeAdresse;
  final DateTime dateHeure;
  final int placesDisponibles;
  final double prixParPassager;
  final List<String> passagersIds;
  final String statut;

  TrajetModel({
    required this.id,
    required this.conducteurId,
    required this.depart,
    required this.departAdresse,
    required this.arrivee,
    required this.arriveeAdresse,
    required this.dateHeure,
    required this.placesDisponibles,
    required this.prixParPassager,
    List<String>? passagersIds,
    this.statut = 'actif',
  }) : passagersIds = passagersIds ?? [];

  factory TrajetModel.fromMap(Map<String, dynamic> m) => TrajetModel(
    id: m['id'] ?? '',
    conducteurId: m['conducteurId'] ?? '',
    depart: (m['depart']?['geopoint']) as GeoPoint,
    departAdresse: m['depart']?['adresse'] ?? '',
    arrivee: (m['arrivee']?['geopoint']) as GeoPoint,
    arriveeAdresse: m['arrivee']?['adresse'] ?? '',
    dateHeure: (m['dateHeure'] is Timestamp) ? (m['dateHeure'] as Timestamp).toDate() : DateTime.now(),
    placesDisponibles: m['placesDisponibles'] ?? 0,
    prixParPassager: (m['prixParPassager'] ?? 0).toDouble(),
    passagersIds: List<String>.from(m['passagersIds'] ?? []),
    statut: m['statut'] ?? 'actif',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'conducteurId': conducteurId,
    'depart': {'geopoint': depart, 'adresse': departAdresse},
    'arrivee': {'geopoint': arrivee, 'adresse': arriveeAdresse},
    'dateHeure': Timestamp.fromDate(dateHeure),
    'placesDisponibles': placesDisponibles,
    'prixParPassager': prixParPassager,
    'passagersIds': passagersIds,
    'statut': statut,
  };
}
