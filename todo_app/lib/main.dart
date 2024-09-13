import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/view/forgot_password_view.dart';
import 'package:todo_app/view/home_view.dart';
import 'package:todo_app/view/login_view.dart';
import 'package:todo_app/view/profile-view.dart';
import 'package:todo_app/view/register_view.dart';
import 'package:todo_app/view/verfiy_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, brightness: Brightness.light)),
      debugShowCheckedModeBanner: false,
      home: const HomeView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verfiyEmailRoute: (context) => const VerfiyEmailView(),
        forgotPasswordRoute: (context) => const ForgotPasswordView(),
        homeRoute: (context) => const HomeView(),
        profileRoute: (context) => const ProfileView(),
        // createTaskRoute: (context) => const CreateTaskView(taskServices: null,),
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailverified) {
                return const HomeView();
              } else {
                return const VerfiyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
