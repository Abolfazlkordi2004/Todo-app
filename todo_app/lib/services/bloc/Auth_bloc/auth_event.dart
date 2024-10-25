import 'package:flutter/material.dart';

@immutable
class AuthEvent {
  const AuthEvent();
}

class InitializeAppEvent extends AuthEvent {
  const InitializeAppEvent();
}

class HomeEvent extends AuthEvent {
  const HomeEvent();
}

class LoginEvent extends AuthEvent {
  final String name;
  final String password;

  const LoginEvent({
    required this.name,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String password;
  final String number;
  const RegisterEvent({
    required this.name,
    required this.number,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

class ConfirmNumberEvent extends AuthEvent {
  final String oTP;
  const ConfirmNumberEvent({required this.oTP});
}

class ResendOTPEvent extends AuthEvent {
  final String oTP;
  final String phoneNumber;
  final BuildContext context;
  const ResendOTPEvent({
    required this.context,
    required this.oTP,
    required this.phoneNumber,
  });
}

class ChangePhoneNumberEvent extends AuthEvent {
  const ChangePhoneNumberEvent();
}
