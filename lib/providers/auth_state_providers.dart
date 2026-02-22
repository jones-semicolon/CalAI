import 'package:calai/providers/global_provider.dart';
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
    // ✅ stop firestore FIRST
    await ref.read(globalDataProvider.notifier).disposeListeners();

    // small delay lets Firestore detach cleanly
    await Future.delayed(const Duration(milliseconds: 150));

    // ✅ THEN sign out
    await FirebaseAuth.instance.signOut();
  }
}