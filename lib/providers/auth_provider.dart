import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  static const List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/photoslibrary',
    'https://www.googleapis.com/auth/photoslibrary.readonly'
  ];

  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn(scopes: scopes).signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Future<String?> getAccessToken() async {
    final googleUser = await GoogleSignIn().signInSilently();
    final googleAuth = await googleUser?.authentication;
    return googleAuth?.accessToken;
  }
}
