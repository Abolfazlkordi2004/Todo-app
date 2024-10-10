import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/class/task_services.dart';
import 'package:todo_app/constant/routes.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/services/auth/auth_service.dart';
import 'package:todo_app/theme/theme_mode.dart';
import 'package:todo_app/theme/theme_notifer.dart';
import 'package:todo_app/view/create_task_view.dart';
import 'package:todo_app/view/forgot_password_view.dart';
import 'package:todo_app/view/home_view.dart';
import 'package:todo_app/view/login_view.dart';
import 'package:todo_app/view/profile_view.dart';
import 'package:todo_app/view/register_view.dart';
import 'package:todo_app/view/verfiy_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
          debugShowCheckedModeBanner: false,
          home: const AuthWidget(),
          routes: {
            homeRoute: (context) => const HomeView(),
            createTaskRoute: (context) => CreateTaskView(
                  taskServices: TaskServices(),
                ),
            loginRoute: (context) => const LoginView(),
            profileRoute: (context) => const ProfileView(),
            registerRoute: (context) => const RegisterView(),
            forgotPasswordRoute: (context) => const ForgotPasswordView(),
            verfiyEmailRoute: (context) => const VerfiyEmailView(),
          },
        );
      },
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

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
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
