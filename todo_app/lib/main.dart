import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/test.dart';
import 'package:todo_app/view/forgot_password_view.dart';
import 'package:todo_app/view/home-view.dart';
import 'package:todo_app/view/login_view.dart';
import 'package:todo_app/view/register_view.dart';
import 'package:todo_app/view/verfiy_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      home: const Homeview(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verfiyEmailRoute: (context) => const VerfiyEmailView(),
        forgotPasswordRoute: (context) => const ForgotPasswordView(),
        homeRoute: (context) => const Homeview(),
      },
    ),
  );
}
