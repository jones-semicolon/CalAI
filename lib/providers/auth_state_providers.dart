import 'package:calai/providers/global_provider.dart';
import 'package:calai/providers/user_provider.dart'; // Make sure to import this!
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authServiceProvider = Provider((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref ref;
  AuthService(this.ref);

  Future<void> logout() async {
    // 1. Stop active custom Firestore listeners
    await ref.read(globalDataProvider.notifier).disposeListeners();

    // 2. Nuke the Firestore cache and connection (Bulletproofs the app against zombie streams)
    try {
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
    } catch (e) {
      // Catch in case Firestore was already terminated
      print("Firestore termination note: $e");
    }

    ref.invalidate(userProvider);
    
    // Add any other specific providers here that hold personal data 
    // (e.g., ref.invalidate(stepTrackerProvider);)

    // ✅ 3. The Safety Gap
    // This tiny delay prevents the "Tried to rebuild multiple times in the same frame" error.
    await Future.delayed(const Duration(milliseconds: 50));
    // 5. Sign out of Firebase Auth
    await FirebaseAuth.instance.signOut();
  }
}