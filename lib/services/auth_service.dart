import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance; // Add this line

  // Stream to listen for authentication changes
  Stream<User?> get user => _auth.authStateChanges();

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // --- NEW CODE STARTS HERE ---
      // After signing in, save user data to Firestore
      if (user != null) {
        final DocumentReference userDoc = _db.collection('users').doc(user.uid);
        await userDoc.set({
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true)); // Use merge to avoid overwriting todos
      }
      // --- NEW CODE ENDS HERE ---

      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

