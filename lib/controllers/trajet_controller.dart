import 'package:flutter/material.dart';
import 'package:devm_covoitlocal/services/firestore_service.dart';
import 'package:devm_covoitlocal/models/trajet.dart';

class TrajetController extends ChangeNotifier {
  final FirestoreService _svc;

  List<TrajetModel> trajets = [];
  bool loading = false;
  String? error;

  TrajetController(this._svc) {
    _listenTrajets();
  }

  void _listenTrajets() {
    _svc.streamTrajetsActifs().listen((list) {
      trajets = list;
      notifyListeners();
    }, onError: (e) {
      error = e.toString();
      notifyListeners();
    },);
  }

  Future<void> createTrajet(TrajetModel t) async {
    loading = true; notifyListeners();
    try {
      await _svc.createTrajet(t);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> reserver(String trajetId, String userId) async {
    loading = true; notifyListeners();
    try {
      await _svc.reserverPlace(trajetId, userId);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }
}
