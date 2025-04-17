import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory UserProfile.fromFirebaseUser(User user) {
    return UserProfile(
      id: user.uid,
      name: user.email?.split('@')[0] ?? 'User',
      email: user.email ?? '',
    );
  }
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserProfile? _userProfile;
  bool _isInitializing = true;

  bool get isAuthenticated => _auth.currentUser != null;
  UserProfile? get userProfile => _userProfile;
  bool get isInitializing => _isInitializing;

  Future<void> initializeAuth() async {
    try {
      _auth.authStateChanges().listen((User? user) async {
        if (user != null) {
          try {
            final doc =
                await _firestore.collection('users').doc(user.uid).get();
            if (doc.exists) {
              final data = doc.data()!;
              _userProfile = UserProfile(
                id: user.uid,
                name: data['name'] ?? user.email?.split('@')[0] ?? 'User',
                email: user.email ?? '',
              );
            } else {
              _userProfile = UserProfile.fromFirebaseUser(user);
            }
          } catch (e) {
            _userProfile = UserProfile.fromFirebaseUser(user);
          }
        } else {
          _userProfile = null;
        }
        _isInitializing = false;
        notifyListeners();
      });
    } catch (e) {
      _isInitializing = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        _userProfile = UserProfile.fromFirebaseUser(result.user!);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        final userProfile = UserProfile(
          id: user.uid,
          name: name,
          email: email,
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userProfile.toMap());
      }

      await _auth.signOut(); // Sign out after registration
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userProfile = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  Future<void> updateProfile({required String name}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _firestore.collection('users').doc(user.uid).update({'name': name});

      _userProfile = UserProfile(
        id: user.uid,
        name: name,
        email: user.email ?? '',
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
