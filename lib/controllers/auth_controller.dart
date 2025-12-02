import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:devm_covoitlocal/services/firestore_service.dart';
import 'package:devm_covoitlocal/models/user.dart';

class AuthController extends ChangeNotifier {
  final FirestoreService _svc;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? user;
  bool loading = false;
  String? error;

  AuthController(this._svc);

  Future<void> checkAuth() async {
    final u = _auth.currentUser;
    if (u != null) {
      loading = true; notifyListeners();
      user = await _svc.getUser(u.uid);
      loading = false; notifyListeners();
    } else {
      user = null; notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      loading = true; error = null; notifyListeners();
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = await _svc.getUser(cred.user!.uid);
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String nom) async {
    try {
      loading = true; error = null; notifyListeners();
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final newUser = UserModel(uid: cred.user!.uid, nom: nom, email: email);
      await _svc.createUser(newUser);
      user = newUser;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}
