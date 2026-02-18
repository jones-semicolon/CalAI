import 'package:calai/enums/user_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Instances
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // State
  static bool _isInitialized = false;

  /// Initialize Google Sign In (Required for v7)
  static Future<void> initSignIn() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        // serverClientId:
        // '530467491766-dlp2dkncq9t3urv9lf56vmfuiim1kfj7.apps.googleusercontent.com',
      );
      _isInitialized = true;
    }
  }

  /// Deletes the user document and related sub-collections
  Future<void> deleteUserDocumentAndData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final batch = FirebaseFirestore.instance.batch();

    // List of all your sub-collections
    final subCollections = ['dailyLogs', 'stats', 'savedFood'];

    for (var collectionName in subCollections) {
      final collectionRef = userRef.collection(collectionName);
      final snapshots = await collectionRef.get();

      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
    }

    // Finally, delete the parent user document itself
    batch.delete(userRef);

    await batch.commit();
  }

  /// Deletes the Firebase Auth account
  Future<void> deleteAuthAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 1. Attempt initial delete
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // 2. Identify the provider (Google, etc.)
        // Since your app heavily uses Google Sign-In:
        final googleProvider = GoogleAuthProvider();

        try {
          // 3. Force re-auth (This shows the Google picker again)
          await user.reauthenticateWithProvider(googleProvider);

          // 4. Try deleting again now that the session is "fresh"
          await user.delete();

        } catch (reAuthError) {
          throw Exception("Authentication failed. Please log out and back in to delete.");
        }
      } else {
        rethrow;
      }
    }
  }

  // ==========================================
  // ANONYMOUS SIGN IN
  // ==========================================

  static Future<UserCredential> signInAsGuest() async {
    try {
      // 1. Authenticate anonymously
      final UserCredential userCredential = await _auth.signInAnonymously();

      // 2. Sync User to Firestore (so the user exists in your DB)
      if (userCredential.user != null) {
        await _syncUserToFirestore(userCredential.user!, UserProvider.anonymous.value);
      }

      return userCredential;
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
      rethrow;
    }
  }

  // ==========================================
  // GOOGLE SIGN IN
  // ==========================================

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      await initSignIn();

      // 1. Authenticate user
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 2. Retrieve tokens
      final idToken = googleUser.authentication.idToken;
      final authorizationClient = googleUser.authorizationClient;

      // 3. Request Scopes/Authorization
      var authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      var accessToken = authorization?.accessToken;

      // 4. Retry if Access Token is missing (v7 specific handling)
      if (accessToken == null) {
        final retryAuthorization = await authorizationClient
            .authorizationForScopes(['email', 'profile']);

        if (retryAuthorization?.accessToken == null) {
          throw FirebaseAuthException(
              code: "token_error", message: "Failed to retrieve access token");
        }
        accessToken = retryAuthorization!.accessToken;
      }

      // 5. Create Credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // 6. Sign in to Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      // 7. Sync User to Firestore
      if (userCredential.user != null) {
        await _syncUserToFirestore(userCredential.user!, UserProvider.google.value);
      }

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      rethrow;
    }
  }

  // ==========================================
  // MAGIC LINK (Passwordless)
  // ==========================================

  /// Sends the Magic Link to the user's email
  static Future<void> sendMagicLink(String email) async {
    try {
      const String projectId = 'calai-11be1';

      // 2. Use the default Firebase domain instead of page.link
      const String url = 'https://$projectId.firebaseapp.com/verify';
      // Configuration for where to redirect the user
      var acs = ActionCodeSettings(
        // This URL must be whitelisted in Firebase Console > Authentication > Settings > Authorized Domains
        url: url,
        handleCodeInApp: true,
        iOSBundleId: 'com.example.calai', // CHANGE THIS to your iOS Bundle ID
        androidPackageName: 'com.example.calai', // CHANGE THIS to your Android Package Name
        androidInstallApp: true,
        androidMinimumVersion: '12',
      );

      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: acs,
      );

      // NOTE: You should verify here that you saved the email locally (e.g., SharedPreferences).
      // You will need it again when the user clicks the link to finish the sign-in.
      print("Magic link sent to $email");
    } catch (e) {
      print("Error sending magic link: $e");
      rethrow;
    }
  }

  static Future<UserCredential?> linkGoogleAccount() async {
    await initSignIn();

    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
    final idToken = googleUser.authentication.idToken;
    final authorizationClient = googleUser.authorizationClient;

    var authorization = await authorizationClient.authorizationForScopes(['email', 'profile']);
    var accessToken = authorization?.accessToken;

    if (accessToken == null) {
      final retry = await authorizationClient.authorizationForScopes(['email', 'profile']);
      accessToken = retry?.accessToken;
      if (accessToken == null) throw Exception("Token error");
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    try {
      final userCredential = await _auth.currentUser!.linkWithCredential(credential);

      if (userCredential.user != null) {
        await _syncUserToFirestore(userCredential.user!, UserProvider.google.value);
      }
      return userCredential;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        // This Google account is already linked to another user UID.
        // You must decide: do you sign into that old account, or force merge?
        print('This google account already exists as a separate user.');
        rethrow;
      }
      rethrow;
    }
  }

  /// Verifies the link and signs the user in
  static Future<UserCredential?> signInWithMagicLink(String email, String emailLink) async {
    try {
      if (_auth.isSignInWithEmailLink(emailLink)) {
        final userCredential = await _auth.signInWithEmailLink(
          email: email,
          emailLink: emailLink,
        );

        if (userCredential.user != null) {
          await _syncUserToFirestore(userCredential.user!, 'magic_link');
        }

        return userCredential;
      } else {
        throw FirebaseAuthException(
            code: 'invalid-link', message: 'The link is invalid or expired.');
      }
    } catch (e) {
      print('Magic Link Sign-In Error: $e');
      rethrow;
    }
  }

  // ==========================================
  // SHARED HELPERS
  // ==========================================

  /// Syncs user data to Firestore (Works for Google, Magic Link, & Anonymous)
  static Future<void> _syncUserToFirestore(User user, String provider) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Brand new user (Anonymous or first-time Google)
      await userDoc.set({
        'uid': user.uid,
        'profile': {
          'provider': provider,
          'photoURL': user.photoURL ?? '',
          'email': user.email ?? '',
          'name': user.displayName ?? '',
        },
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await userDoc.update({
        'profile.provider': provider,
        'profile.photoURL': user.photoURL ?? '',
        'profile.email': user.email ?? '',
        'profile.name': user.displayName ?? '',
      });
    }
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}