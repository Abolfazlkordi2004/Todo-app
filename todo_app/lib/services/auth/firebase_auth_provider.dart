// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:todo_app/firebase_options.dart';
// import 'package:todo_app/services/auth/auth_provider.dart' as customprovider;
// import 'package:todo_app/services/auth/auth_user.dart';
// import 'package:todo_app/services/auth/auth_exception.dart';

// class FirebaseAuthProvider implements customprovider.AuthProvider {
//   @override
//   Future<void> initialize() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   }

//   @override
//   AuthUser? get currentUser {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       return AuthUser.fromFirebase(user);
//     } else {
//       return null;
//     }
//   }

//   @override
//   Future<AuthUser> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = currentUser;
//       if (user != null) {
//         return user;
//       } else {
//         throw UserNotLoggedInAuthExceptions();
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         throw UserNotFoundAuthException();
//       } else if (e.code == 'wrong-password') {
//         throw WrongPasswordAuthException();
//       } else {
//         throw GenericAuthExceptions();
//       }
//     } catch (_) {
//       throw GenericAuthExceptions();
//     }
//   }

//   @override
//   Future<AuthUser> createUser({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final user = currentUser;
//       if (user != null) {
//         return user;
//       } else {
//         throw UserNotLoggedInAuthExceptions();
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-email') {
//         throw InvalidEmailAuthExceptions();
//       } else if (e.code == 'email-already-in-use') {
//         throw EmailAlreadyInUseAuthExceptions();
//       } else if (e.code == 'weak-password') {
//         throw WeakPasswordAuthExceptions();
//       } else {
//         throw GenericAuthExceptions();
//       }
//     } catch (_) {
//       throw GenericAuthExceptions();
//     }
//   }

//   @override
//   Future<void> logOut() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await FirebaseAuth.instance.signOut();
//     } else {
//       throw UserNotLoggedInAuthExceptions();
//     }
//   }

//   @override
//   Future<void> sendEmailVerification() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await user.sendEmailVerification();
//     } else {
//       throw UserNotLoggedInAuthExceptions();
//     }
//   }

//   @override
//   Future<void> sendResetPassword({required String toEmail}) async {
//     try {
//       await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'invalid-email') {
//         throw InvalidEmailAuthExceptions();
//       } else if (e.code == 'user-not-found') {
//         throw UserNotFoundAuthException();
//       } else {
//         throw GenericAuthExceptions();
//       }
//     } catch (_) {
//       throw GenericAuthExceptions();
//     }
//   }
// }
