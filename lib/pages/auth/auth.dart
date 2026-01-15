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
        serverClientId:
        '530467491766-dlp2dkncq9t3urv9lf56vmfuiim1kfj7.apps.googleusercontent.com',
      );
      _isInitialized = true;
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
        await _syncUserToFirestore(userCredential.user!, 'google');
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
      // TODO: Replace with your actual Bundle ID and Package Name
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

  /// Syncs user data to Firestore (Works for Google & Magic Link)
  static Future<void> _syncUserToFirestore(User user, String provider) async {
    final userDoc =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '',
        'provider': provider, // 'google' or 'magic_link'
        'createdAt': FieldValue.serverTimestamp(),
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