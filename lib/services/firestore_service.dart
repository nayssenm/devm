import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devm_covoitlocal/models/user.dart';
import 'package:devm_covoitlocal/models/trajet.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // UTILISATEURS
  Future<void> createUser(UserModel u) async {
    await _firestore.collection('utilisateurs').doc(u.uid).set(u.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('utilisateurs').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // TRAJETS
  Future<void> createTrajet(TrajetModel t) async {
    await _firestore.collection('trajets').doc(t.id).set(t.toMap());
  }

  Stream<List<TrajetModel>> streamTrajetsActifs() {
    return _firestore.collection('trajets')
      .where('statut', isEqualTo: 'actif')
      .where('dateHeure', isGreaterThan: Timestamp.fromDate(DateTime.now().subtract(const Duration(days:1))))
      .snapshots()
      .map((snap) => snap.docs.map((d) => TrajetModel.fromMap(d.data())).toList());
  }

  // Résolution simple par id
  Future<TrajetModel?> getTrajetById(String id) async {
    final doc = await _firestore.collection('trajets').doc(id).get();
    if (!doc.exists) return null;
    return TrajetModel.fromMap(doc.data()!);
  }

  // Réserver une place (transaction)
  Future<void> reserverPlace(String trajetId, String userId) async {
    final ref = _firestore.collection('trajets').doc(trajetId);
    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Trajet introuvable');
      final data = snap.data()!;
      final places = data['placesDisponibles'] ?? 0;
      final List<dynamic> passagers = data['passagersIds'] ?? [];
      if (places <= 0) throw Exception('Plus de place disponible');
      passagers.add(userId);
      tx.update(ref, {
        'placesDisponibles': places - 1,
        'passagersIds': passagers,
      });
    });
  }
}
