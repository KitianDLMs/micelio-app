// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthService {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   // stream to listen to authentication state changes
//   Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

//   // Get user email
//   String getUserEmail() => _firebaseAuth.currentUser?.email ?? "User";

//   // apple login method
//   Future<UserCredential?> signInWithApple() async {
//     try { 
//       final appleCredential = await SignInWithApple.getAppleIDCredential(scopes: 
//         [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ]
//       );

//       final oAuthCredential = OAuthProvider('apple.com').credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode
//       );

//       return await _firebaseAuth.signInWithCredential(oAuthCredential);
//     } catch (e) {
//       print('error during the sign in with apple $e');
//       return null;
//     }
//   }

//   // logout
//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
// }