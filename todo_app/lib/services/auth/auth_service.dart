import 'package:todo_app/services/auth/auth_provider.dart';
import 'package:todo_app/services/auth/auth_user.dart';
import 'package:todo_app/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> login({required String email, required String password}) =>
      provider.login(email: email, password: password);

  @override
  Future<void> sendResetPassword({required String toEmail}) =>
      provider.sendResetPassword(toEmail: toEmail);

  @override
  Future<void> initialize() => provider.initialize();
}
