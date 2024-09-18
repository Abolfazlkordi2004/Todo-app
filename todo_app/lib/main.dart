import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/class/theme_notifire.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/constant/theme.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/view/create_task_view.dart';
import 'package:todo_app/view/forgot_password_view.dart';
import 'package:todo_app/view/home_view.dart';
import 'package:todo_app/view/login_view.dart';
import 'package:todo_app/view/profile_view.dart';
import 'package:todo_app/view/register_view.dart';
import 'package:todo_app/view/verfiy_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeNotifier(),
    child: const MyApp(),
  ));
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const MyApp(),
          routes: {
            loginRoute: (context) => const LoginView(),
            registerRoute: (context) => const RegisterView(),
            verfiyEmailRoute: (context) => const VerfiyEmailView(),
            forgotPasswordRoute: (context) => const ForgotPasswordView(),
            homeRoute: (context) => const HomeView(),
            profileRoute: (context) => const ProfileView(),
            createTaskRoute: (context) => CreateTaskView(),
          },
        );
      },
    );
  }
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
