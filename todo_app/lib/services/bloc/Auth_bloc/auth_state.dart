import 'package:flutter/material.dart';

@immutable
class AuthState {
  final bool isLoading;
  final String textLoading;
  const AuthState({
    required this.isLoading,
    this.textLoading = "در حال بارگذاری",
  });
}

class InitializeAppState extends AuthState {
  const InitializeAppState() : super(isLoading: false);
}

class HomeState extends AuthState {
  final Exception? exception;
  const HomeState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class ConfirmNumberState extends AuthState {
  final Exception? exception;
  const ConfirmNumberState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class RegisteringState extends AuthState {
  final Exception? exception;
  const RegisteringState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class LoggedInState extends AuthState {
  final Exception? exception;
  const LoggedInState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}

class ResendOTPState extends AuthState {
  final Exception? exception;
  const ResendOTPState({
    bool isLoading = false,
    this.exception,
  }) : super(isLoading: false);
}
